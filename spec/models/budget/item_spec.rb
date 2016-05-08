require 'spec_helper'
require 'models/budget/item'

describe Model::Budget::Item do
  it 'should initialize successfully' do
    subject = Model::Budget::Item.new description: 'test description',
                                      occurance:   :daily,
                                      id:          5
    subject.description.must_equal 'test description'
    subject.occurance.must_equal 'daily'
    subject.id.must_equal 5
    subject.amount.must_equal 0.00
  end

  it 'should throw exception if wrong occurance is set' do
    assert_raises ArgumentError do
      Model::Budget::Item.new description: 'test description', occurance: :century
    end
  end

  it 'should have defaults' do
    subject = Model::Budget::Item.new occurance: :daily, id: 5
    subject.description.must_equal 'no description'
    subject.amount.must_equal 0.00
    subject.category.must_equal 'misc'
  end

  it 'should show amount in float of 2 decimal places' do
    subject = Model::Budget::Item.new amount: 3967.593, id: 23 # -4.9966654
    subject.amount.must_equal(3967.59)
  end

  it 'should handle debit items' do
    subject = Model::Budget::Item.new description: 'debit item', id: 1,
                                occurance: :daily, amount: 4.12
    subject.amount.must_equal 4.12
    subject.debit?.must_equal true
    subject.credit?.must_equal false
  end

  it 'should handle credit items' do
    subject = Model::Budget::Item.new description: 'credit item', occurance: :daily,
                                amount: 313_45.45, id: 3
    subject.as_credit!
    subject.amount.must_equal(-313_45.45)
    subject.debit?.must_equal false
    subject.credit?.must_equal true
  end

  it 'should handle display amount_for' do
    Common::Occurance.any_instance.stubs(:generate_price_conversion).returns(proc { |x| x })
    subject = Model::Budget::Item.new description: 'something', occurance: :daily,
                                amount: 888.88, id: 4
    subject.amount_for(:weekly).must_equal 888.88
  end

  it 'should change occurance and amount when the occurance is changed' do
    expected_value = 3
    Common::Occurance.any_instance.stubs(:generate_price_conversion).returns(proc { expected_value })
    subject = Model::Budget::Item.new description: 'something', occurance: :daily,
                                amount: 888.88, id: 4
    subject.occurance = 'monthly'
    subject.amount.must_equal expected_value
    subject.occurance.to_s.must_equal 'monthly'
  end

  it 'should use == correctly' do
    test_1 =  Model::Budget::Item.new description: 'same same', occurance: :monthly,
                                category: 'fakeCategory', amount: 3, id: 20
    test_2 =  Model::Budget::Item.new description: 'same same', occurance: :daily,
                                category: 'fakeCategory', amount: 3, id: 20
    result = test_1 == test_2
    result.must_equal true

    test_3 = Model::Budget::Item.new description: 'diff diff', occurance: :daily,
                              amount: 3, id: 1
    result = test_1 == test_3
    result.must_equal false

    test_4 = Model::Budget::Item.new description: 'same same', occurance: :daily,
                              amount: 3, category: 'fakeCategory', id: 1
    result = test_1 == test_4
    result.must_equal false
  end

  it 'should raise exceiption if == uses wrong class' do
    assert_raises ArgumentError do
      test_1 = Model::Budget::Item.new description: 'same same', occurance: :monthly,
                                amount: 3, id: 1
      test_2 = ['same same', :monthly, 3, 1]
      test_1 == test_2
    end
  end
end
