require_relative 'spec_helper'
require 'spreadsheet_adapter'

describe Spreadsheet::Adapter do
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
    WorksheetMapper.stubs(:map_article)
    @spreadsheet = MockSpreadSheet.new @worksheets
  end

  it 'should initialize with a spreadsheet' do
    fake_session = mock(spreadsheet_by_key: @spreadsheet)
    GoogleDrive.stubs(:saved_session).returns(fake_session)
    subject = Spreadsheet::Adapter.new 'somekey'
    subject.spreadsheet_available?.must_equal true
  end

  it 'should not have a spreadsheet when no key is given' do
    subject = Spreadsheet::Adapter.new
    subject.spreadsheet_available?.must_equal false
  end

  it 'should map only budget worksheets' do
    fake_session = mock(spreadsheet_by_key: @spreadsheet)
    GoogleDrive.stubs(:saved_session).returns(fake_session)
    subject = Spreadsheet::Adapter.new 'somekey'
    result = subject.budgets
    result.length.must_equal 2
  end
end
