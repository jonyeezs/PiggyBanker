require 'openssl'
OpenSSL::SSL::VERIFY_PEER &&= OpenSSL::SSL::VERIFY_NONE # FIXME: use SSL
require 'google/api_client'
require 'google_drive'
require_relative 'worksheetmapper.rb' # TODO: must be a better way to include this

# TODO: figure out how to make constants
module Spreadsheet
  class Adapter
    include WorksheetMapper

    def initialize(spreadsheet_key = nil)
      @nil_key_msg = 'Nil key provided'
      # config_path = PiggyBanker.root + '/' + PiggyBanker.settings['googledrive_settings']
      config_path = 'C:/Development/PiggyBanker/configurations/googledrive_config.json'
      @session = GoogleDrive.saved_session(config_path)
      load_spreadsheet(spreadsheet_key)
    end

    def load_spreadsheet(spreadsheet_key)
      fail ArgumentError, @nil_key_msg if spreadsheet_key.nil?
      @spreadsheet = @session.spreadsheet_by_key(spreadsheet_key)
    end

    def spreadsheet_available?
      !@spreadsheet.nil?
    end

    def budgets
      budgets = worksheets_with_title('budget')
      budgets.map! do |ws|
        WorksheetMapper::Article.map ws
      end
    end

    private

    def worksheets_with_title(title)
      @spreadsheet.worksheets.select { |ws| ws.title.downcase.include? title }
    end
  end
end
