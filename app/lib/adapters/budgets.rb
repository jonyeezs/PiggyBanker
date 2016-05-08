# TODO: rethink your structure how does it relate from your adapters all the way to your representation of your models
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
      @articles.find { |article| article.year == year }
    end

    def size
      @articles.size
    end
  end
end
