require 'lib/adapters/budgets'
# TODO: spec it
class Budgets < BaseRouter
  budgets = Adapter::Budgets.new
  get '' do
    year = params['year']
    respond_with budgets: budgets.articles
  end

  get '/years' do
    respond_with years: budgets.available_years
  end

  get '/year/:year' do
    retrieved_budget = budgets.by_year params[:year]
    respond_with budget: retrieved_budget
  end
end
