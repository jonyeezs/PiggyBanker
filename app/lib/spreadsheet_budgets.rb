require 'spreadsheet_adapter'

module Spreadsheet
  class Budgets
    def initialize
      adapter = Spreadsheet::Adapter.new PiggyBanker.settings['spreadsheet_key']
      @articles = adapter.budgets
    end

    def by_year(year)
      index = @articles.index { |article| article.year == year }
      @articles[index]
    end

    def size
      @articles.size
    end
  end
end
