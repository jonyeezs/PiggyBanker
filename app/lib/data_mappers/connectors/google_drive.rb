OpenSSL::SSL::VERIFY_PEER &&= OpenSSL::SSL::VERIFY_NONE # FIXME: use SSL
# #TODO Connects to the database in this case it will be google drive
module Adapter
  module Connector
    class GoogleDrive
      def initialize(spreadsheet_key)
        fail ArgumentError if spreadsheet_key.nil?
        config_path = PiggyBanker.root + '/' + PiggyBanker.settings['googledrive_settings']
        session = GoogleDrive.saved_session(config_path)
        @spreadsheet = session.spreadsheet_by_key spreadsheet_key
      end

      def tables
        @spreadsheet.worksheets
      end

      def create
      end

      ## @param the values needed to update year, value
      # then converts it?
      def update
      end

      def delete
      end
    end
  end
end
