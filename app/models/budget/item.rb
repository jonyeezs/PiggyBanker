# Think-about-it: use a factory pattern to differentiate expense and income
#                 http://katafrakt.me/2015/05/15/when-you-call-object-new/
require 'lib/common/occurance'

module Model
  module Budget
    class Item
      ITEM_ERROR_MESSAGE = 'This is not a budget item'
      private_constant :ITEM_ERROR_MESSAGE

      attr_accessor :description, :category, :amount
      attr_reader :id

      def initialize(params = {})
        u_occurance = params.fetch(:occurance, :monthly)
        @occurance = Common::Occurance.new u_occurance
        @id = params.fetch(:id)
        @description = params.fetch(:description, 'no description')
        @category = params.fetch(:category, 'misc')
        @amount = params.fetch(:amount, 0.00).to_f.round(2) #FIXME: figure out how to use bankers rounding
      end

      def occurance
        @occurance.to_s
      end

      def occurance=(new_occurance)
        @occurance = Common::Occurance.new new_occurance
      end

      def to_s
        "#{@description} (Category: #{@category}) #{@amount}, #{@occurance}"
      end

      def debit?
        @amount < 0
      end

      def credit?
        @amount > 0
      end

      def amount_for(occurance_type)
        target = Common::Occurance.new occurance_type
        proc_price = @occurance.generate_price_conversion target
        proc_price.call(@amount)
      end

      def ==(other)
        fail ArgumentError, ITEM_ERROR_MESSAGE unless other.instance_of?(Budget::Item)
        @description == other.description && @amount == other.amount &&
          @id == other.id && @category == other.category
      end
    end
  end
end
