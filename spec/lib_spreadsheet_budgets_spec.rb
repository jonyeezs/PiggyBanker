require_relative 'spec_helper'
require 'spreadsheet_budgets'

describe Spreadsheet::Budgets do
  before do
    adapter = Object.new
    adapter.stubs(:budgets).returns(
      [
        stub(year: '2016'),
        stub(year: '2017')
      ])
    Spreadsheet::Adapter.stubs(:new).returns(adapter)
    @subject = Spreadsheet::Budgets.new
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
