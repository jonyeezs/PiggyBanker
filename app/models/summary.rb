module Model
  class Summary
    attr_reader :year, :breakdowns

    def initialize(year, items)
      @year = year
      @breakdowns = items
    end
  end
end
