require 'lib/adapters/budgets'

class Budgets < BaseRouter
  get '/' do
    respond_with budgets: Adapter::Budgets.new.articles
  end

  get '/years' do
    respond_with years: Adapter::Budgets.new.available_years
  end

  get '/years/:year' do
    articles = Adapter::Budgets.new.by_year params[:year]
    # queries
    articles.change_occurances! params['occurance'] if params.key? 'occurance'
    articles.items = filter_items_by_transaction(articles, params['transaction_type']) if params.key? 'transaction_type'

    respond_with budget: articles.items
  end

  def filter_items_by_transaction(articles, transaction)
    if transaction == 'debit'
      articles.debit_items
    else
      articles.credit_items
    end
  end
end
