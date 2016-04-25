require 'spec_helper'
# FIXME: test exactly what the mapper should be doing

describe 'WorksheetMapper' do
  before do
    @worksheet = MockWorksheet.new
    @num_of_incomes = 1
    @num_of_expenses = 3
    @worksheet[0] = %w(should ignore #1)
    @worksheet[1] = %w('should ignore #2')
    @worksheet[2] = %w('should ignore #3')
    @worksheet[3] = %w('should ignore #4')
    @worksheet[4] = %w('should ignore #5')
    @worksheet[5] = ['INCOME', 1]
    @worksheet[6] = ['Salary', 'Cash-in', 'monthly', '7331.20']
    @worksheet[7] = [' ', '', '', '']
    @worksheet[8] = ['Expenses', ' ']
    @worksheet[9] = ['Grocery', 'Food', 'weekly', '23.50']
    @worksheet[10] =  ['Internet', 'bill', 'monthly', '60.50']
    @worksheet[11] =  ['Movies', 'leisure', 'monthly', '40.70']
  end

  describe 'map_item' do
    it 'should map expense item' do
      item = WorksheetMapper.map_item @worksheet, 11, false
      item.id.must_equal 11
      item.description.must_equal @worksheet[11, 1]
      item.category.must_equal @worksheet[11, 2]
      item.occurance.must_equal @worksheet[11, 3]
      item.credit?.must_equal true
    end
    it 'should map item\'s amount correctly' do
      item = WorksheetMapper.map_item @worksheet, 6, true
      item.amount.must_equal 7331.20
    end
  end

  describe 'Expense' do
    it 'should map only expenses' do
      results = WorksheetMapper.map_expenses @worksheet
      results.length.must_equal @num_of_expenses
    end
  end

  describe 'Income' do
    it 'should map only incomes' do
      results = WorksheetMapper.map_incomes @worksheet
      results.length.must_equal @num_of_incomes
    end
  end

  describe 'Article' do
    it 'should map article' do
      result_model_budget_article = WorksheetMapper.map_article @worksheet
      result_model_budget_article.year.must_be_kind_of String
      assert result_model_budget_article.items.length > 1
    end

    it 'should get all expenses and incomes items' do
      result = WorksheetMapper.get_items @worksheet
      result.length.must_equal @num_of_expenses + @num_of_incomes
    end
  end
end
