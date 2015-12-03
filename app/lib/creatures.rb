class Creatures
  CREATURES = {
    puppies:    1,
    platypuses: 2,
    canaries:   1,
    Heffalumps: 3,
    tigers:     1
  }

  def show_creatures
    return_value = 'We\'ve got creatures of sort like: '

    filter_integer = proc { |item| item.is_a? Integer }
    filter_string = proc { |item| item.is_a? String }
    my_array = [1, 'two', 3]

    my_other_array = [[1, 2, 3], %w(four one four)]

    my_array.select(&filter_integer)
    my_other_array.flatten!.select(&filter_string)
    random_index = rand(1..3)
    creatures = CREATURES.select do |_key, value|
      value == random_index
    end
    return_value + creatures.keys.to_sentence
  end

  def declare_my_animal
    puts 'This move is the best!'
  end
end
