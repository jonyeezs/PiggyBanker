require 'models/summary'

require 'date'

module Services
  class Summarizer
    def initialize(article)
      @article = article
    end

    def map_budget(occurance_type = nil, as_statement = false)
      @article.change_occurances! occurance_type unless occurance_type.nil?

      breakdowns = summarize(@article.items)

      breakdowns = modify_total_budget_as_statement breakdowns unless as_statement.nil?

      Model::Summary.new @article.year, breakdowns
    end

    private

    def summarize(article_items)
      group_by_category = article_items.group_by(&:category)
      group_by_category.each_with_object({}) do |(category, items), hash|
        group_by_occurance = items.group_by(&:occurance)
        hash[category] = total_up_occurances(group_by_occurance)
      end
    end

    def total_up_occurances(occurance_groups)
      occurance_groups.each_with_object({}) do |(occurance, items), hash|
        total = items.reduce(0) { |a, e| a + e.amount }
        hash[occurance] = total
      end
    end

    def modify_total_budget_as_statement(breakdowns)
      days = (Date.today - Date.new(@article.year.to_i)).to_i
      breakdowns.each_with_object({}) do |(category, occurances), hash|
        updated_occurances = update_total occurances, days
        hash[category] = updated_occurances
      end
    end

    def update_total(occurances, days)
      require 'lib/common/occurance'
      occur_types = Common::Occurances

      occurances.each_with_object({}) do |(occurance, total), hash|
        day_count = (days / occur_types.get_ratio(occurance)).floor
        hash[occurance] = (total * day_count)
      end
    end
  end
end
