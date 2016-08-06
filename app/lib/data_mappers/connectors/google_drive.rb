require 'google_drive'
OpenSSL::SSL::VERIFY_PEER &&= OpenSSL::SSL::VERIFY_NONE # FIXME: use SSL

module DataMappers
  module Connectors
    class GoogleDriveConnector
      def initialize(spreadsheet_key)
        fail ArgumentError if spreadsheet_key.nil?
        config_path = PiggyBanker.root + '/' + PiggyBanker.settings['googledrive_settings']
        session = GoogleDrive.saved_session(config_path)
        @spreadsheet = session.spreadsheet_by_key spreadsheet_key
      end

      def tables
        @spreadsheet.worksheets
      end

      def update(worksheet)
        updated_worksheet = @spreadsheet.worksheets.find { |ws| ws.title == worksheet.title }
        worksheet.cells.each do |cell|
          updated_worksheet[cell.row, cell.column] = cell.value
        end
        updated_worksheet.save
      end
    end
  end
end
