# TODO: Actually the years should be in its own uri. And should have a hal link to budgets and budgets could be id-ed by the year.
require 'lib/services/budgets'

class Budgets < BaseRouter
  get '/' do
    respond_with items: budget.all_articles
  end

  get '/years' do
    respond_with years: budget.available_years
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
    Services::Budgets.new
  end

  def filter_items_by_transaction(articles, transaction)
    if transaction == 'debit'
      articles.debit_items
    else
      articles.credit_items
    end
  end
end
