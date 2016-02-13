# TODO: use price gem
module Budget
  class Item
    attr_accessor :id, :description, :occurance, :category, :amount

    # NOTE: values are an increment of its previous occurance type
    #       in ascending order
    def occurances
      {
        daily:       1,
        weekly:      7,
        fortnightly: 2,
        monthly:     2,
        quarterly:   3,
        semiannual:  2,
        annually:    2
      }
    end

    def initialize(params = {})
      u_occurance = params.fetch(:occurance, :monthly)
      @occur_error = "Wrong occurance (#{u_occurance}). Try " + occurances.keys.to_sentence
      @item_error = 'This is not a budget item'
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
      fail ArgumentError, @item_error unless other.instance_of?(Budget::Item)
      @description == other.description && @amount == other.amount &&
        @category == other.category
    end

    private

    def occurance_index
      occurances.keys.find_index(@occurance)
    end

    def buildup_price(till_occurance)
      new_value = @amount.to_f
      buildup_array = occurances.keys.drop(occurance_index + 1)
      buildup_array.each do |name|
        new_value *= occurances.fetch(name)
        break if name == till_occurance # calculate its last occurance as well
      end
      new_value.round(2)
    end

    def breakdown_price(till_occurance)
      new_value = @amount.to_f
      breakdown_array = occurances.keys.take(occurance_index + 1).reverse
      breakdown_array.each do |name|
        break if name == till_occurance
        new_value /= occurances.fetch(name)
      end
      new_value.round(2)
    end

    def occurance_direction(target)
      if occurances.keys.find_index(target) > occurance_index
        :up
      else
        :down
      end
    end

    def handle_valid_occurance(occurance)
      fail ArgumentError, @occur_error unless occurances.key?(occurance.to_sym)
    end
  end
end
