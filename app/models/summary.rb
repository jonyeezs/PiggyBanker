module Model
  class Summary
    attr_reader :year, :breakdowns

    def initialize(year, items)
      @year = year
      @breakdowns = items
    end

    def to_class
      classified_breakdown = @breakdowns.map do |category, occurances|
        summary_group = SummaryGroup.new category, occurances
        summary_group.to_class
      end
      self.class.new @year, classified_breakdown
    end
  end

  class SummaryGroup
    attr_reader :category, :occurances
    def initialize(category, occurances)
      @category = category
      @occurances = occurances
    end

    def to_class
      classified_items = @occurances.map do |occurance, amount|
        SummaryItem.new occurance, amount
      end
      self.class.new @category, classified_items
    end
  end

  class SummaryItem
    attr_reader :type, :amount
    def initialize(type, amount)
      @type = type
      @amount = amount
    end
  end
end
