module Common
  module Occurances
    # NOTE: values are all in ratio to a single day
    #       occurances must be in lowercase
    LIST =
      [
        { name: 'daily',       ratio: 1 },
        { name: 'weekly',      ratio: 7 },
        { name: 'fortnightly', ratio: 14 },
        { name: 'monthly',     ratio: 28 },
        { name: 'quarterly',   ratio: 84 },
        { name: 'semiannual',  ratio: 168 },
        { name: 'annually',    ratio: 336 }
      ]

    def self.list
      LIST
    end

    def self.to_s
      Occurances.list.map { |e| e[:name] }.to_sentence
    end
  end

  class Occurance
    OCCURANCE_ERROR_MSG = "Occurance does not exist. Try #{Occurances}"
    ERROR_MSG = 'This is not a valid Occurance object'
    private_constant :OCCURANCE_ERROR_MSG, :ERROR_MSG
    attr_reader :occurance

    def initialize(occurance)
      @occurance = occurance.to_s.downcase
      handle_valid_occurance
    end

    def index
      Occurances.list.index { |this| compare_name(this) }
    end

    def ratio
      Occurances.list[index][:ratio]
    end

    def generate_price_conversion(new_occurance)
      fail ArgumentError, ERROR_MSG unless new_occurance.instance_of?(Common::Occurance)
      if new_occurance.index > index
        proc_buildup_price(new_occurance)
      elsif new_occurance.index < index
        proc_breakdown_price(new_occurance)
      else
        proc { |price| price.round }
      end
    end

    def to_s
      @occurance
    end

    def to_sym
      @occurance.to_sym
    end

    private

    def handle_valid_occurance
      fail ArgumentError, OCCURANCE_ERROR_MSG unless exist?
    end

    def exist?
      Occurances::LIST.any? { |this| compare_name(this) }
    end

    def compare_name(occurance)
      occurance[:name] == @occurance
    end

    def proc_buildup_price(higher_occurance)
      multiplier = higher_occurance.ratio / ratio
      proc { |price| price * multiplier }
    end

    def proc_breakdown_price(lower_occurance)
      diminisher = ratio / lower_occurance.ratio
      proc { |price| price / diminisher }
    end
  end
end
