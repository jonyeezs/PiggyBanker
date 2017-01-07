require_relative './connectors/postgres'
require_relative './mappers/postgres'

module DataMappers
  class Actual
    ## Should get a model
    def initialize
      @postgres = DataMappers::Connectors::PostgresConnector.new 'ledger'
    end

    def articles
      DataMappers::Mappers::Postgres.map_article @postgres.tables
    end

    # def update(year, patch_changes)
    #   worksheet = DataMappers::Mappers::GoogleDrive.map_worksheet year, patch_changes
    #   @google_drive.update worksheet
    # end
    #
    def add(article, item)
      table = DataMappers::Mappers::Postgres.map_table_with_new_rows @postgres.table_name, article.year, [item]
      @postgres.add_row table
    end
  end
end
