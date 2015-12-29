require_relative 'spec_helper'

describe 'Budget Item' do
  it 'should initialize successfully' do
    subject = Budget::Item.new 'test description', :daily
    subject.description.must_equal 'test description'
    subject.occurance.must_equal :daily
    subject.amount.must_equal 0.00
  end

  it 'should throw exception if wrong occurance is set' do
    assert_raises ArgumentError do
      Budget::Item.new 'test description', :century
    end
  end

  it 'should handle debit items' do
    subject = Budget::Item.new 'debit item', :daily, -4.12
    subject.amount.must_equal(-4.12)
    subject.debit?.must_equal true
    subject.credit?.must_equal false
    subject.debit.must_equal 4.12
  end

  it 'should handle credit items' do
    subject = Budget::Item.new 'debit item', :daily, 9
    subject.amount.must_equal 9.00
    subject.debit?.must_equal false
    subject.credit?.must_equal true
    subject.credit.must_equal 9.00
  end

  it 'should handle display amount for higher occurance' do
    subject = Budget::Item.new 'something', :daily, 1
    subject.amount_for(:weekly).must_equal 7.00
    subject.amount_for(:monthly).must_equal 28.00
    subject.amount_for(:yearly).must_equal 336.00
  end

  it 'should handle display amount for lower occurance' do
    subject = Budget::Item.new 'something', :yearly, 12
    subject.amount_for(:daily).must_equal 0.04
    subject.amount_for(:weekly).must_equal 0.25
    subject.amount_for(:monthly).must_equal 1.00
    subject.amount_for(:yearly).must_equal 12.00
  end

  it 'should handle display amount for an occurance in the middle' do
    subject = Budget::Item.new 'jokers to the left..', :monthly, 3
    subject.amount_for(:daily).must_equal 0.11
    subject.amount_for(:weekly).must_equal 0.75
    subject.amount_for(:monthly).must_equal 3.00
    subject.amount_for(:yearly).must_equal 36.00
  end
end
