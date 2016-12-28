require 'spec_helper'
require 'lib/services/summarizer'
require 'models/article'
require 'models/budget/item'

describe Services::Summarizer do
  before do
    items = []
    items.push(Model::Budget::Item.new description: ' 1',
                                       category:    'income',
                                       occurance:   :daily,
                                       id:          3)
    items.push(Model::Budget::Item.new description: 'monthly 1',
                                       category:    'leisure',
                                       occurance:   :monthly,
                                       id:          10)
    items.push(Model::Budget::Item.new description: 'daily 2',
                                       category:    'income',
                                       occurance:   :annually,
                                       id:          1)
    article = Model::Article.new '2016', items
    @subject = Services::Summarizer.new article
  end

  describe 'map_budget' do
    before do
      @result = @subject.map_budget
    end
  end
  it 'should set the year' do
    @result.year.must_equal '2016'
  end

  it 'should categorize the items' do
    @result.breakdowns.keys.size.must_equal 2
    @result.breakdowns.keys.must_match %w(income leisure)
  end

  it 'should have total of items in the breakdowns for each occurance' do
    breakdowns = @result.breakdowns.values_at('income', 'leisure')
    breakdowns[0].keys.size.must_equal 2
    breakdowns[0].keys.must_match %w(daily yearly)
    breakdowns[0].values_at('daily', 'yearly').must_match [3, 1]
    breakdowns[1].keys.size.must_equal 1
    breakdowns[1].keys.must_match %w(monthly)
    breakdowns[1]['monthly'].must_equal 10
  end
end
