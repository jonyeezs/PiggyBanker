require 'spreadsheet_adapter'
# TODO: spec it
# FIXME: find out why constantize removes the trailing s
class Budget < BaseRouter
  adapter = Spreadsheet::Adapter.new PiggyBanker.settings['spreadsheet_key']

  get '/available' do
    respond_with availability: adapter.spreadsheet_available?
  end

  get '/all' do
    respond_with budgets: adapter.budgets
  end
end
