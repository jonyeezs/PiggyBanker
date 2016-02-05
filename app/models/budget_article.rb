require_relative 'budget_item'

module Budget
  class Article
    attr_accessor :year
    attr_reader :items

    def initialize(year, items = [])
      @error_msg = 'This is not a budget item'
      @year = year
      @items = items
    end

    def add_item(item)
      fail ArgumentError, @error_msg unless item.instance_of?(Budget::Item)
      @items.push(item)
    end

    def remove_item(to_del)
      @items.delete_at(get_index(to_del))
    end

    def update_item(old, updated)
      @items[get_index(old)] = updated
    end

    private

    def get_index(target)
      @items.index { |item| item == target }
    end
  end
end
