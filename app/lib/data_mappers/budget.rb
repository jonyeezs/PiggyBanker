# TODO: Maybe move away from the idea of data_mappers that does the relationship.
#       But make it DTO as the object that mutates the persistent database.
require_relative './connectors/google_drive'
require_relative './mappers/google_drive'

## Maps the object from domain to persistent
## Make things easier everything should be dealt at the article level
## To use the connector given
module DataMappers
  class Budget
    ## Should get a model
    def initialize
      @google_drive = DataMappers::Connectors::GoogleDriveConnector.new PiggyBanker.settings['spreadsheet_key']
    end

    def budgets
      raw_budgets = @google_drive.tables.select { |ws| ws.title.downcase.include? 'budget' }
      @budgets = raw_budgets.map do |ws|
        DataMappers::Mappers::GoogleDrive.map_article ws
      end
    end

    def update(year, patch_changes)
      worksheet = DataMappers::Mappers::GoogleDrive.map_worksheet year, patch_changes
      @google_drive.update worksheet
    end
  end
end
