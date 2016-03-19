require 'spreadsheet_budgets'
# TODO: spec it
# FIXME: find out why constantize removes the trailing s
class Budgets < BaseRouter
  get '' do
    return response_internal_error unless adapter.spreadsheet_available?
    respond_with budgets: adapter.budgets
  end

  get '/:year' do
    test = "Hello to you #{params[:name]}. "
    test += some_creatures.show_creatures
    respond_with message: test
  end
end
