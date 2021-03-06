require 'lib/common/occurance'

module Model
  module Budget
    class Item
      ITEM_ERROR_MESSAGE = 'This is not a budget item'
      private_constant :ITEM_ERROR_MESSAGE

      attr_accessor :description, :category, :amount
      attr_reader :id

      # FIXME: use merge for defaults
      def initialize(params = {})
        u_occurance = params.fetch(:occurance, :monthly)
        @occurance = Common::Occurance.new u_occurance
        @id = params.fetch(:id)
        @description = params.fetch(:description, 'no description')
        @category = params.fetch(:category, 'misc')
        @amount = params.fetch(:amount, 0.00).to_f.round(2) # TODO: figure out how to use bankers rounding
      end

      def occurance
        @occurance.to_s
      end

      def to_h # TODO: how to extend to_json
        {
          id:          @id,
          description: @description,
          category:    @category,
          occurance:   @occurance.to_s,
          amount:      @amount
        }
      end

      def occurance=(new_occurance)
        occurance = Common::Occurance.new new_occurance
        @amount = @occurance.generate_price_conversion(occurance).call(@amount)
        @occurance = occurance
      end

      def as_credit!
        @amount = -@amount
      end

      def as_debit!
        @amount = @amount.abs
      end

      def to_s
        "#{@description} (Category: #{@category}) #{@amount}, #{@occurance}"
      end

      def debit?
        @amount > 0
      end

      def credit?
        @amount < 0
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
