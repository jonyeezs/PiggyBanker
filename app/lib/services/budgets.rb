require 'lib/data_mappers/mapper_factory'

module Adapter
  class Budgets
    def initialize
      data_mapper = DataMappers::MapperFactory.new 'budget'
      @articles = data_mapper.budgets
    end

    def available_years
      @articles.map(&:year)
    end

    def by_year(year)
      @articles.find { |article| article.year == year }
    end

    def size
      @articles.size
    end
  end
end
