# TODO: use inheritance
module Model
  module Actual
    class Item
      attr_accessor :description, :category, :amount, :date
      attr_reader :id

      def initialize(params = {})
        @id = params.fetch(:id)
        @description = params.fetch(:description, 'no description')
        @category = params.fetch(:category, 'misc')
        @amount = params.fetch(:amount, 0.00).to_f.round(2) # TODO: figure out how to use bankers rounding
        @date = params.fetch(:date)
      end

      def to_h # TODO: how to extend to_json
        {
          id:          @id,
          description: @description,
          category:    @category,
          date:        @date,
          amount:      @amount
        }
      end
    end
  end
end
