# TODO: use price gem
# TODO: use a factory pattern to differentiate expense and income
#       http://katafrakt.me/2015/05/15/when-you-call-object-new/
module Model
  module Budget
    class Item
      attr_accessor :description, :occurance, :category, :amount
      attr_reader :id

      OCCURANCE_ERROR_MSG = 'Wrong occurance'
      ITEM_ERROR_MESSAGE = 'This is not a budget item'
      private_constant :OCCURANCE_ERROR_MSG, :ITEM_ERROR_MESSAGE
      # NOTE: values are an increment of its previous occurance type
      #       in ascending order
      OCCURANCES =
        {
          daily:       1,
          weekly:      7,
          fortnightly: 2,
          monthly:     2,
          quarterly:   3,
          semiannual:  2,
          annually:    2
        }

      def initialize(params = {})
        u_occurance = params.fetch(:occurance, :monthly)
        handle_valid_occurance u_occurance
        @id = params.fetch(:id)
        @description = params.fetch(:description, 'no description')
        @occurance = u_occurance.to_sym
        @category = params.fetch(:category, 'misc')
        @amount = params.fetch(:amount, 0.00).to_f
      end

      def to_s
        "#{@description} (Category: #{@category}) #{@amount}, #{@occurance}"
      end

      def debit?
        @amount < 0
      end

      def debit
        self.debit? ? @amount.abs : 0
      end

      def credit?
        @amount > 0
      end

      def credit
        self.credit? ? @amount : 0
      end

      # NOTE: algorithm is done this way so we can add new occurance
      #       without adding more code
      def amount_for(occurance_type)
        handle_valid_occurance occurance_type

        return @amount if occurance_type == @occurance
        if occurance_direction(occurance_type) == :up
          return buildup_price(occurance_type)
        else
          return breakdown_price(occurance_type)
        end
      end

      def ==(other)
        fail ArgumentError, ITEM_ERROR_MESSAGE unless other.instance_of?(Budget::Item)
        @description == other.description && @amount == other.amount &&
          @id == other.id && @category == other.category
      end

      private

      def occurance_index
        OCCURANCES.keys.find_index(@occurance)
      end

      def buildup_price(till_occurance)
        new_value = @amount.to_f
        buildup_array = OCCURANCES.keys.drop(occurance_index + 1)
        buildup_array.each do |name|
          new_value *= OCCURANCES.fetch(name)
          break if name == till_occurance # calculate its last occurance as well
        end
        new_value.round(2)
      end

      def breakdown_price(till_occurance)
        new_value = @amount.to_f
        breakdown_array = OCCURANCES.keys.take(occurance_index + 1).reverse
        breakdown_array.each do |name|
          break if name == till_occurance
          new_value /= OCCURANCES.fetch(name)
        end
        new_value.round(2)
      end

      def occurance_direction(target)
        if OCCURANCES.keys.find_index(target) > occurance_index
          :up
        else
          :down
        end
      end

      def handle_valid_occurance(occurance)
        msg = "#{OCCURANCE_ERROR_MSG}. Try #{OCCURANCES.keys.to_sentence}"
        fail ArgumentError, msg unless OCCURANCES.key?(occurance.to_sym)
      end
    end
  end
end
