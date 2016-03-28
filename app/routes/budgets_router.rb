require 'lib/adapters/budgets'
# TODO: spec it
# FIXME: find out why constantize removes the trailing s
class Budgets < BaseRouter
  budgets = Spreadsheet::Budgets.new
  get '' do
    respond_with budgets: budgets.articles
  end

  get '/:year' do
    retrieved_budget = budgets.by_year params[:year]
    respond_with budget: retrieved_budget
  end
end
