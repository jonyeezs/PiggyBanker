require 'lib/data_mappers/budget'

module Services
  class Budgets
    def initialize
      data_mapper = DataMappers::Budget.new
      @articles = data_mapper.budgets
    end

    def available_years
      @articles.map(&:year)
    end

    def all_articles
      @articles
    end

    def by_year(year)
      @articles.find { |article| article.year == year }
    end

    def size
      @articles.size
    end
  end
end
