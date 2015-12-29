module Budget
  class Item
    attr_accessor :description, :occurance, :amount
    # TODO: use price gem
    def occurances # values are multiplied in ascending order.
      {
        daily:   1,
        weekly:  7,
        monthly: 4,
        yearly:  12
      }
    end

    def initialize(description, occurance, amount = 0.00)
      @occur_error = 'Wrong occurance. Try ' + occurances.keys.to_sentence
      fail ArgumentError, @occur_error unless occurances.key?(occurance.to_sym)
      @description = description
      @occurance = occurance
      @amount = amount.to_f
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

    def amount_for(occurance_type)
      unless occurances.key?(occurance_type.to_sym)
        fail ArgumentError, @occur_error
      end

      return @amount if occurance_type == @occurance
      if occurance_direction(occurance_type) == :up
        return buildup_price(occurance_type)
      else
        return breakdown_price(occurance_type)
      end
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
  end
end
