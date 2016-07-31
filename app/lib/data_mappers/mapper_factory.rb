require_relative 'budget_mapper'

module DataMappers
  class MapperFactory
    def initialize(mapperType)
      # TODO: Propert factory when need to build data mapper for expenditure
      DataMappers::Budget.new if mapperType == 'budget'
    end
  end
end
