require 'spreadsheet_adapter'
# TODO: spec it
# FIXME: find out why constantize removes the trailing s
class Budgets < BaseRouter
  adapter = Spreadsheet::Adapter.new PiggyBanker.settings['spreadsheet_key']

  get '' do
    return response_internal_error unless adapter.spreadsheet_available?
    respond_with budgets: adapter.budgets
  end
end
