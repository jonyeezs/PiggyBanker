require 'lib/services/repository'
require 'lib/data_mappers/actual'

class Actuals < BaseRouter
  get '/' do
    respond_with items: actual.all_articles
  end

  get '/years' do
    respond_with years: actual.available_years
  end

  get '/years/:year' do
    articles_of_year = actual.by_year params[:year]
    respond_with items: articles_of_year.hashed_items
  end

  post '/years/:year' do
    item = JSON.parse request.body.read
    actual.add_item params[:year], item
  end

  def actual
    Services::Repository.new DataMappers::Actual.new
  end
end
