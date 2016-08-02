require_relative 'item'

module Model
  module Budget
    class Article
      ERROR_MSG = 'This is not a budget item'
      private_constant :ERROR_MSG
      attr_reader :year
      attr_accessor :items

      def initialize(year, items = [])
        @year = year
        @items = items
      end

      def hashed_items
        @items.map(&:to_h)
      end

      def change_occurances!(occurance_type)
        @items.each { |item| item.occurance = occurance_type }
      end

      def debit_items
        @items.find_all(&:debit?)
      end

      def credit_items
        @items.find_all(&:credit?)
      end

      private

      def get_index(id)
        @items.index { |item| item.id == id }
      end
    end
  end
end
