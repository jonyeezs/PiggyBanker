# TODO: Actually the years should be in its own uri. And should have a hal link to budgets and budgets could be id-ed by the year.
require 'lib/services/repository'
require 'lib/data_mappers/budget'
require 'lib/services/summarizer'

class Budgets < BaseRouter
  get '/' do
    respond_with items: budget.all_articles
  end

  get '/years' do
    respond_with years: budget.available_years
  end

  get '/years/:year/summary' do
    articles = budget.by_year params[:year]
    summarizer = Services::Summarizer.new articles
    summary = summarizer.map_budget params['occurance'], params['as_statement']
    respond_with summary: summary.to_class
  end

  get '/categories/:year' do
    articles = budget.by_year params[:year]
    categories = articles.items.map(&:category).uniq
    respond_with categories: categories
  end

  get '/years/:year' do
    articles = budget.by_year params[:year]
    # queries
    articles.change_occurances! params['occurance'] if params.key? 'occurance'
    articles.items = filter_items_by_transaction(articles, params['transaction_type']) if params.key? 'transaction_type'

    respond_with items: articles.hashed_items
  end

  patch '/years/:year' do
    patch_changes = JSON.parse request.body.read
    # TODO: would be nice if the parsed data is mapped/bound to our internal models
    budget.update_article params[:year], patch_changes
  end

  post '/years/:year' do
    item = JSON.parse request.body.read
    budget.add_item params[:year], item
  end

  def budget
    Services::Repository.new DataMappers::Budget.new
  end

  def filter_items_by_transaction(articles, transaction)
    if transaction == 'debit'
      articles.debit_items
    else
      articles.credit_items
    end
  end
end
