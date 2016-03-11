require_relative 'spec_helper'
require 'budget_item'

describe Model::Budget::Item do
  it 'should initialize successfully' do
    subject = Model::Budget::Item.new description: 'test description',
                                      occurance:   :daily,
                                      id:          5
    subject.description.must_equal 'test description'
    subject.occurance.must_equal :daily
    subject.id.must_equal 5
    subject.amount.must_equal 0.00
  end

  it 'should throw exception if wrong occurance is set' do
    assert_raises ArgumentError do
      Model::Budget::Item.new description: 'test description', occurance: :century
    end
  end

  it 'should handle debit items' do
    subject = Model::Budget::Item.new description: 'debit item', id: 1,
                                occurance: :daily, amount: -4.12
    subject.amount.must_equal(-4.12)
    subject.debit?.must_equal true
    subject.credit?.must_equal false
    subject.debit.must_equal 4.12
  end

  it 'should handle credit items' do
    subject = Model::Budget::Item.new description: 'credit item', occurance: :daily,
                                amount: 9, id: 3
    subject.amount.must_equal 9.00
    subject.debit?.must_equal false
    subject.credit?.must_equal true
    subject.credit.must_equal 9.00
  end

  it 'should have defaults' do
    subject = Model::Budget::Item.new occurance: :daily, id: 5
    subject.description.must_equal 'no description'
    subject.amount.must_equal 0.00
    subject.category.must_equal 'misc'
  end

  it 'should handle display amount for higher occurance' do
    subject = Model::Budget::Item.new description: 'something', occurance: :daily,
                                amount: 1, id: 4
    subject.amount_for(:weekly).must_equal 7.00
    subject.amount_for(:monthly).must_equal 28.00
    subject.amount_for(:annually).must_equal 336.00
  end

  it 'should handle display amount for lower occurance' do
    subject = Model::Budget::Item.new description: 'something', id: 3,
                                occurance: :annually, amount: 12
    subject.amount_for(:daily).must_equal 0.04
    subject.amount_for(:weekly).must_equal 0.25
    subject.amount_for(:monthly).must_equal 1.00
    subject.amount_for(:annually).must_equal 12.00
  end

  it 'should handle display amount for an occurance in the middle' do
    subject = Model::Budget::Item.new description: 'jokers to the left..', id: 4,
                                occurance: :monthly, amount: 3
    subject.amount_for(:daily).must_equal 0.11
    subject.amount_for(:weekly).must_equal 0.75
    subject.amount_for(:monthly).must_equal 3.00
    subject.amount_for(:annually).must_equal 36.00
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
