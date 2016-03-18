OpenSSL::SSL::VERIFY_PEER &&= OpenSSL::SSL::VERIFY_NONE # FIXME: use SSL
require 'worksheetmapper'

# TODO: figure out how to make constants
module Spreadsheet
  class Adapter
    def initialize(spreadsheet_key = nil)
      config_path = PiggyBanker.root + '/' + PiggyBanker.settings['googledrive_settings']
      @session = GoogleDrive.saved_session(config_path)
      load_spreadsheet(spreadsheet_key) unless spreadsheet_key.nil?
    end

    def load_spreadsheet(spreadsheet_key)
      @spreadsheet = @session.spreadsheet_by_key(spreadsheet_key)
    end

    def spreadsheet_available?
      !@spreadsheet.nil?
    end

    def budgets
      budgets = worksheets_with_title('budget')
      budgets.map! do |ws|
        WorksheetMapper.map_article ws # FIXME: NoMethodError
      end
    end

    private

    def worksheets_with_title(title)
      @spreadsheet.worksheets.select { |ws| ws.title.downcase.include? title }
    end
  end
end
