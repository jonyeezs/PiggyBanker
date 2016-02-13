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

    def remove_item(id)
      @items.delete_at(get_index(id))
    end

    def update_item(updated)
      @items[get_index(updated)] = updated
    end

    private

    def get_index(id)
      @items.index { |item| item.id == id }
    end
  end
end
