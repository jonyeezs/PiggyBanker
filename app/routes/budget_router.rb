require 'spreadsheet_adapter'

class Budget < BaseRouter
  adapter = Spreadsheet::Adapter.new PiggyBanker.settings['spreadsheet_key']

  get '/available' do
    respond_with availability: adapter.spreadsheet_available?
  end

  get '/budgets' do
    respond_with budgets: adapter.budgets
  end
end
