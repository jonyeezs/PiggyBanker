require 'spec_helper'
require 'models/budget/article'
require 'models/budget/item'

describe Model::Budget::Article do
  before do
    @subject = Model::Budget::Article.new '2016'
  end

  it 'should create an article successfully' do
    @subject.year.must_equal '2016'
    @subject.items.length.must_equal 0
  end

  it 'should add items successfully' do
    test_item = Model::Budget::Item.new id:          3,
                                        description: 'debit item',
                                        occurance:   :daily,
                                        amount:      9,
                                        category:    'income'
    @subject.add_item test_item
    result = @subject.items
    result.length.must_equal 1
    result[0].description.must_equal 'debit item'
    result[0].category.must_equal 'income'
  end

  it 'should not add non budget items' do
    assert_raises ArgumentError do
      not_item = ['faker', :daily, 233]
      @subject.add_item not_item
    end
  end

  describe 'get all transaction types' do
    before do
      debit_item = Model::Budget::Item.new id: 1, amount: 4
      credit_item = Model::Budget::Item.new id: 2, amount: (-2)
      items = [debit_item, debit_item, credit_item]
      @subject = Model::Budget::Article.new '2016', items
    end
    describe 'find_all_debit' do
      it 'should return 2 items' do
        @subject.debit_items.count.must_equal 2
      end
    end
    describe 'find_all_credit' do
      it 'should return 1 items' do
        @subject.credit_items.count.must_equal 1
      end
    end
  end
end
