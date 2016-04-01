require_relative 'spreadsheet'

module Adapter
  class Budgets
    attr_accessor :articles

    def initialize
      adapter = Adapter::Spreadsheet.new PiggyBanker.settings['spreadsheet_key']
      @articles = adapter.budgets
    end

    def available_years
      @articles.map(&:year)
    end

    def by_year(year)
      index = @articles.index { |article| article.year == year }
      # TODO: handle situations where index is not founds
      @articles[index]
    end

    def size
      @articles.size
    end
  end
end
