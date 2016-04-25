require 'spec_helper'
require 'lib/adapters/spreadsheet'

describe Adapter::Spreadsheet do
  before do
    @worksheets = []
    non_related_worksheet = MockWorksheet.new
    non_related_worksheet.title = 'This is not the worksheet you are looking for'
    @worksheets.push(non_related_worksheet)
    budget_worksheet = MockWorksheet.new
    budget_worksheet.title = 'budget 2016'
    @worksheets.push(budget_worksheet)
    actual_worksheet = MockWorksheet.new
    actual_worksheet.title = 'Actual 2016'
    @worksheets.push(actual_worksheet)
    other_budget_worksheet = MockWorksheet.new
    other_budget_worksheet.title = 'BUDGET 2017 with more text'
    @worksheets.push(other_budget_worksheet)
    WorksheetMapper.stubs(:map_article).returns('someobject')
    @spreadsheet = MockSpreadSheet.new @worksheets
    @fake_session = mock(spreadsheet_by_key: @spreadsheet)
    GoogleDrive.stubs(:saved_session).returns(@fake_session)
  end

  it 'should initialize with a spreadsheet' do
    subject = Adapter::Spreadsheet.new 'somekey'
    subject.spreadsheet_available?.must_equal true
  end

  it 'should not have a spreadsheet when no key is given' do
    @fake_session.unstub(:spreadsheet_by_key) # TODO: should have a expected_not or something..find out how
    subject = Adapter::Spreadsheet.new
    subject.spreadsheet_available?.must_equal false
  end

  it 'should map only budget worksheets' do
    subject = Adapter::Spreadsheet.new 'somekey'
    result = subject.budgets
    result.length.must_equal 2
  end
end