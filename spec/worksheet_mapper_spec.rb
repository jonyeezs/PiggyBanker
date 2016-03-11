require_relative 'spec_helper'

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
    @worksheet[6] = ['Salary', 'Cash-in', 'monthly', '7331.00']
    @worksheet[7] = [' ', '', '', '']
    @worksheet[8] = ['Expenses', ' ']
    @worksheet[9] = ['Grocery', 'Food', 'weekly', '23.50']
    @worksheet[10] =  ['Internet', 'bill', 'monthly', '60.50']
    @worksheet[11] =  ['Movies', 'leisure', 'monthly', '40.70']
    @subject = SubjectFactory.new.include_module(WorksheetMapper)
  end

  describe 'Common' do
    # TODO: figure out why this isn't working let(:subject) { Class.new { include WorksheetMapper } }

    describe 'starting_range' do
      it 'should return the correct length of ranges' do
        test_value = mock(num_rows: 16)
        @subject.starting_range(test_value).size.must_equal 11
      end
    end
    describe 'income_header' do
      it 'should return true for the appropriate string' do
        @subject.income_header?('INCoME').must_equal true
        @subject.income_header?('incoming').must_equal false
      end
    end
    describe 'expense_header' do
      it 'should return true for the appropriate string' do
        @subject.expense_header?('Expenses').must_equal true
        @subject.expense_header?('INCoME').must_equal false
      end
    end
    describe 'broken_row' do
      it 'should check if a row in a worksheet has any empty cell' do
        @subject.broken_row?(@worksheet, 7).must_equal true
        @subject.broken_row?(@worksheet, 8).must_equal true
        @subject.broken_row?(@worksheet, 9).must_equal false
      end
    end
    describe 'map_item' do
      it 'should map item with - multiplier for expense' do
        item = @subject.map_item @worksheet, 11, -1
        item.id.must_equal 11
        item.description.must_equal @worksheet[11, 1]
        item.category.must_equal @worksheet[11, 2]
        item.occurance.must_equal @worksheet[11, 3].to_sym
        item.debit?.must_equal true
      end
    end
  end

  describe 'Expense' do
    it 'should map only expenses' do
      results = @subject.map_expenses @worksheet
      results.length.must_equal @num_of_expenses
    end
  end

  describe 'Income' do
    it 'should map only incomes' do
      results = @subject.map_incomes @worksheet
      results.length.must_equal @num_of_incomes
    end
  end

  describe 'Article' do
    it 'should map article' do
      result_model_budget_article = @subject.map_article @worksheet
      result_model_budget_article.year.must_be_kind_of String
      assert result_model_budget_article.items.length > 1
    end

    it 'should return the year for a budget title' do
      @subject.year_from_title('2016 Budget').must_equal '2016'
      @subject.year_from_title('BUDGET 2020').must_equal '2020'
    end

    it 'should return the year for an actual title' do
      @subject.year_from_title('2016 actual').must_equal '2016'
      @subject.year_from_title('Actual 2020').must_equal '2020'
    end

    it 'should get all expenses and incomes items' do
      result = @subject.get_items @worksheet
      result.length.must_equal @num_of_expenses + @num_of_incomes
    end
  end
end
