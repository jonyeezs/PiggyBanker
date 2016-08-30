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
        update_row updated_worksheet, worksheet
      end

      def add_row(worksheet)
        updated_worksheet = @spreadsheet.worksheets.find { |ws| ws.title == worksheet.title }
        updated_worksheet.insert_rows worksheet.cells[0].row, 1
        update_row updated_worksheet, worksheet
      end

      private

      def update_row(worksheet_to_be_updated, worksheet_with_updates)
        worksheet_with_updates.cells.each do |cell|
          worksheet_to_be_updated[cell.row, cell.column] = cell.value
        end
        worksheet_to_be_updated.save
      end
    end
  end
end
