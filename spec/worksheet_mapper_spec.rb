require_relative 'spec_helper'

class FakeWorksheet # Implementation simplified from GoogleDrive::Worksheet
  attr_writer :rows_count
  def initialize
    @cells = {}
  end

  def num_rows
    @rows_count
  end

  def [](*args)
    row = args[0]
    col = args[1]
    @cells[[row, col]] || ''
  end

  def []=(*args)
    row = args[0]
    values = args[-1]
    values.each_index do |i|
      @cells[[row, i + 1]] = values[i]
    end
  end
end

describe WorksheetMapper do
  before do
    @worksheet = FakeWorksheet.new
    @num_of_incomes = 1
    @num_of_expenses = 3
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

  describe 'common library' do
    describe 'starting_range' do
      it 'should return the correct length of ranges' do
        test_value = mock(num_rows: 16)
        WorksheetMapper.starting_range(test_value).size.must_equal 11
      end
    end
    describe 'income_header' do
      it 'should return true for the appropriate string' do
        WorksheetMapper.income_header?('INCoME').must_equal true
        WorksheetMapper.income_header?('incoming').must_equal false
      end
    end
    describe 'expense_header' do
      it 'should return true for the appropriate string' do
        WorksheetMapper.expense_header?('Expenses').must_equal true
        WorksheetMapper.expense_header?('INCoME').must_equal false
      end
    end
    describe 'broken_row' do
      it 'should check if a row in a worksheet has any empty cell' do
        WorksheetMapper.broken_row?(@worksheet, 7).must_equal true
        WorksheetMapper.broken_row?(@worksheet, 8).must_equal true
        WorksheetMapper.broken_row?(@worksheet, 9).must_equal false
      end
    end
    describe 'map_item' do
      it 'should map item with - multiplier for expense' do
        item = WorksheetMapper.map_item @worksheet, 11, -1
        item.id.must_equal 11
        item.description.must_equal @worksheet[11, 1]
        item.category.must_equal @worksheet[11, 2]
        item.occurance.must_equal @worksheet[11, 3].to_sym
        item.debit?.must_equal true
      end
    end

    describe 'ExpenseMapper' do
      it 'should map only expenses' do
        results = WorksheetMapper.map_expenses @worksheet
        results.length.must_equal @num_of_expenses
      end
    end

    describe 'IncomeMapper' do
      it 'should map only incomes' do
        results = WorksheetMapper.map_incomes @worksheet
        results.length.must_equal @num_of_incomes
      end
    end
  end
end
