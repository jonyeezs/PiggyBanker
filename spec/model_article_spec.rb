require_relative 'spec_helper'

describe Budget::Article do
  before do
    @subject = Budget::Article.new '2016'
  end

  it 'should create an article successfully' do
    @subject.year.must_equal '2016'
    @subject.items.length.must_equal 0
  end

  it 'should add items successfully' do
    test_item = Budget::Item.new description: 'debit item',
                                 occurance:   :daily,
                                 amount:      -9,
                                 category:    'income'
    @subject.add_item test_item
    result = @subject.items
    result.length.must_equal 1
    result[0].description.must_equal 'debit item'
    result[0].category.must_equal 'income'
    result[0].debit?.must_equal true
  end

  it 'should not add non budget items' do
    assert_raises ArgumentError do
      not_item = ['faker', :daily, 233]
      @subject.add_item not_item
    end
  end
end
