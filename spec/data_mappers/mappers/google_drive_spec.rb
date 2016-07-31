require 'spec_helper'

describe 'DataMappers::Mappers::GoogleDrive' do
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
    @worksheet[6] = ['Salary', 'Cash-in', 'monthly', '23.00']
    @worksheet[7] = [' ', '', '', '']
    @worksheet[8] = ['Expenses', ' ']
    @worksheet[9] = ['Grocery', 'Food', 'weekly', '23.50']
    @worksheet[10] =  ['Internet', 'bill', 'monthly', '60.50']
    @worksheet[11] =  ['Movies', 'leisure', 'monthly', '7331.20']
    @result = WorksheetMapper.map_article @worksheet
  end

  describe 'map_article' do
    it 'should map to article object' do
      @result.year.must_be_kind_of String
      assert @result.is_a? Model::Budget::Article
    end

    it 'should get all expenses and incomes items' do
      @result.items.must_equal @num_of_expenses + @num_of_incomes
    end

    it 'should map expense item correctly' do
      item = @result.items.find { |i| i.id == 11 }
      item.description.must_equal @worksheet[11, 1]
      item.category.must_equal @worksheet[11, 2]
      item.occurance.must_equal @worksheet[11, 3]
      item.credit?.must_equal true
      item.amount.must_equal 7331.20
    end

    it 'should map income item correctly' do
      item = @result.items.find { |i| i.id == 6 }
      item.description.must_equal @worksheet[6, 1]
      item.category.must_equal @worksheet[6, 2]
      item.occurance.must_equal @worksheet[6, 3]
      item.debit?.must_equal true
      item.amount.must_equal 23.00
    end
  end
end
