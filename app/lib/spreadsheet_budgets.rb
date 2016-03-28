require 'spreadsheet_adapter'

module Spreadsheet
  class Budgets
    attr_accessor :articles

    def initialize
      adapter = Spreadsheet::Adapter.new PiggyBanker.settings['spreadsheet_key']
      @articles = adapter.budgets
    end

    def by_year(year)
      index = @articles.index { |article| article.year == year }
      # TODO: handle situations where index is not found
      @articles[index]
    end

    def size
      @articles.size
    end
  end
end
