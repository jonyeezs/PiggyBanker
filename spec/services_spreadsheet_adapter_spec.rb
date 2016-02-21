require_relative 'spec_helper'

describe Spreadsheet::Adapter do
  before do
    @worksheet = MockWorksheet.new
    @worksheet[0] = %w(should ignore #1)
    @worksheet[1] = %w('should ignore #2')
    @worksheet[2] = %w('should ignore #3')
    @worksheet[3] = %w('should ignore #4')
    @worksheet[4] = %w('should ignore #5')
    @worksheet[5] = ['INCOME', 1]
    @worksheet[6] = ['Salary', 'Cash-in', 'monthly', '7331.00']
    @worksheet[7] = [' ', '', '', '']
    @worksheet[8] = ['Expenses', ' ']
    @worksheet[9] = ['Grocery', 'Food', 'weekly', '23.50']
    @worksheet[10] =  ['Internet', 'bill', 'monthly', '60.50']
    @worksheet[11] =  ['Movies', 'leisure', 'monthly', '40.70']
    @worksheet.rows_count = 12
  end

  it 'should initialize with a spreadsheet' do
    fake_session = mock(spreadsheet_by_key: @worksheet)
    GoogleDrive.stubs(:saved_session).returns(fake_session)
    subject = Spreadsheet::Adapter.new 'somekey'
    subject.spreadsheet_available?.must_equal true
  end

  it 'should not have a spreadsheet when no key is given' do
    subject = Spreadsheet::Adapter.new
    subject.spreadsheet_available?.must_equal false
  end
end
