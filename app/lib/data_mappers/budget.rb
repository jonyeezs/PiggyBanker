require_relative './mapper/google_drive'

## Maps the object from domain to persistent
## Make things easier everything should be dealt at the article level
## To use the connector given
module DataMappers
  class Budget
    ## Should get a model
    def initialize
      @google_drive = DataMappers::Connectors::GoogleDrive.new PiggyBanker.settings['spreadsheet_key']
    end

    def budgets
      raw_budgets = @google_drive.tables.select { |ws| ws.title.downcase.include? 'budget' }
      @budgets = raw_budgets.map do |ws|
        BudgetMapper.map_article ws
      end
    end

    ## @param Model::Budget::Article
    def update
      ## Converts it straight to what i need in the Connector
      ## DataMappers::Connectors::GoogleDrive.update(the googledrive dto)
    end
  end
end
