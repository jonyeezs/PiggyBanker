require 'spreadsheet_adapter'

class Budget < BaseRouter
  adapter = Spreadsheet::Adapter.new PiggyBanker.settings['spreadsheet_key']

  get '/available' do
    respond_with message: adapter.spreadsheet_available?
  end
end
