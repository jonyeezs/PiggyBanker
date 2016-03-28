require 'spec_helper'
require 'lib/adapters/budgets'

describe Adapter::Budgets do
  before do
    adapter = Object.new
    adapter.stubs(:budgets).returns(
      [
        stub(year: '2016'),
        stub(year: '2017')
      ])
    Adapter::Spreadsheet.stubs(:new).returns(adapter)
    @subject = Adapter::Budgets.new
  end

  it 'should initialize with elements in articles' do
    assert @subject.size > 1
  end

  it 'should get a budget object by the correct year' do
    result = @subject.by_year('2017')
    result.year.must_equal '2017'
  end

  it 'should return all budget articles' do
    assert @subject.articles.size == 2
  end
end
