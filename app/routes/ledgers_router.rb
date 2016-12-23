require 'lib/services/repository'
require 'lib/data_mappers/ledger'

class Ledgers < BaseRouter
  get '/' do
    respond_with items: ledger.all_articles
  end

  get '/years' do
    respond_with years: ledger.available_years
  end

  get '/years/:year' do
    articles_of_year = ledger.by_year params[:year]
    respond_with items: articles_of_year.hashed_items
  end

  post '/years/:year' do
    item = JSON.parse request.body.read
    ledger.add_item params[:year], item
  end

  def ledger
    Services::Repository.new DataMappers::Ledger.new
  end
end
