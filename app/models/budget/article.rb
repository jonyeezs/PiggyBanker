require_relative 'item'

module Model
  module Budget
    class Article
      ERROR_MSG = 'This is not a budget item'
      private_constant :ERROR_MSG
      attr_reader :items, :year

      def initialize(year, items = [])
        @year = year
        @items = items
      end

      def add_item(item)
        fail ArgumentError, ERROR_MSG unless item.instance_of?(Budget::Item)
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
end
