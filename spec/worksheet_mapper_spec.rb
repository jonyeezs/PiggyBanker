require_relative 'spec_helper'

describe WorksheetMapper do
  before do
    @worksheet = [%w('should ignore #1'),
                  %w('should ignore #2'),
                  %w('should ignore #3'),
                  %w('should ignore #4'),
                  %w('should ignore #5'),
                  ['INCOME', 1],
                  ['Salary', 'Cash-in', 'monthly', '7331.00'],
                  [' ', '', '', ''],
                  ['Expenses', ' '],
                  ['Grocery', 'Food', 'weekly', '23.50'],
                  ['Internet', 'bill', 'monthly', '60.50'],
                  ['Movies', 'leisure', 'monthly', '40.70']
                 ]
  end
  describe 'common library' do
    it 'starting_range should return the correct length of ranges' do
      test_value = mock(num_rows: 16)
      WorksheetMapper.starting_range(test_value).size.must_equal 11
    end

    it 'income_header should return true for the appropriate string' do
      WorksheetMapper.income_header?('INCoME').must_equal true
      WorksheetMapper.income_header?('incoming').must_equal false
    end

    it 'expense_header should return true for the appropriate string' do
      WorksheetMapper.expense_header?('Expenses').must_equal true
      WorksheetMapper.expense_header?('INCoME').must_equal false
    end

    it 'empty_row should check if a row in a worksheet has any empty cell' do
      WorksheetMapper.empty_row?(@worksheet, 7).must_equal true
      WorksheetMapper.empty_row?(@worksheet, 8).must_equal true
      WorksheetMapper.empty_row?(@worksheet, 9).must_equal false
    end
  end
end
