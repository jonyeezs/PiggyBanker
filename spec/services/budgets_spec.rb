require 'spec_helper'

describe Services::Budgets do
  before do
    data_mapper = Object.new
    data_mapper.stubs(:budgets).returns(
      [
        stub(year: '2016'),
        stub(year: '2017')
      ])
    DataMappers::Budget.stubs(:new).returns(data_mapper)
    @subject = Services::Budgets.new
  end

  it 'should initialize with elements in articles' do
    assert @subject.size > 1
  end

  it 'should get a budget object by the correct year' do
    result = @subject.by_year('2017')
    result.year.must_equal '2017'
  end

  it 'should return all budget articles' do
    assert @subject.all_articles.size == 2
  end
end
