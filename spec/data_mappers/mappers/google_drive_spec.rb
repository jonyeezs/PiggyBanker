require 'spec_helper'
require 'lib/data_mappers/mappers/google_drive'
describe DataMappers::Mappers::GoogleDrive do
  before do
    @worksheet = MockWorksheet.new
  end

  describe 'map_article' do
    before do
      DataMappers::Mappers::GoogleDrive::RequestHelper.any_instance.stubs(:year_from_title).returns('year')
      DataMappers::Mappers::GoogleDrive::RequestHelper.any_instance.stubs(:get_items).returns([])
      @result = DataMappers::Mappers::GoogleDrive.map_article @worksheet
    end
    it 'should map to article object' do
      @result.year.must_equal 'year'
      assert @result.is_a? Model::Budget::Article
    end
  end

  describe 'Requesthelper' do
    before do
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
      @subject_instance = DataMappers::Mappers::GoogleDrive::RequestHelper.new
    end
    describe 'map_item' do
      it 'should map correctly' do
        item = @subject_instance.map_item @worksheet, 11, false
        item.id.must_equal 11
        item.description.must_equal @worksheet[11, 1]
        item.category.must_equal @worksheet[11, 2]
        item.occurance.must_equal @worksheet[11, 3]
        item.credit?.must_equal true
        item.amount.must_equal(-7331.20)
      end
    end
    describe 'map_expenses' do
      it 'should map only map items that are expenses' do
        results = @subject_instance.map_expenses @worksheet
        results.length.must_equal @num_of_expenses
      end
    end
    describe 'map_incomes' do
      it 'should map only map items that are incomes' do
        results = @subject_instance.map_incomes @worksheet
        results.length.must_equal @num_of_incomes
      end
    end
    describe 'get_items' do
      it 'should get all expenses and incomes items' do
        result = @subject_instance.get_items @worksheet
        result.length.must_equal @num_of_expenses + @num_of_incomes
      end
    end
    describe 'starting_range' do
      it 'should return the correct length of ranges' do
        test_value = mock(num_rows: 16)
        @subject_instance.starting_range(test_value).size.must_equal 11
      end
    end
    describe 'income_header' do
      it 'should return true for the appropriate string' do
        @subject_instance.income_header?('INCoME').must_equal true
        @subject_instance.income_header?('incoming').must_equal false
      end
    end
    describe 'expense_header' do
      it 'should return true for the appropriate string' do
        @subject_instance.expense_header?('Expenses').must_equal true
        @subject_instance.expense_header?('INCoME').must_equal false
      end
    end
    describe 'broken_hash_row' do
      it 'should check if a row in a worksheet has any empty cell' do
        bad_hash_row = { a: ' ', b: '', c: '', d: '' }
        another_bad_hash_row = { a: 'Expenses', b: ' ' }
        good_hash_row = { a: 'Grocery', b: 'Food', c: 'weekly', d: '23.50' }
        @subject_instance.broken_hash_row?(bad_hash_row).must_equal true
        @subject_instance.broken_hash_row?(another_bad_hash_row).must_equal true
        @subject_instance.broken_hash_row?(good_hash_row).must_equal false
      end
    end
    describe 'year_from_title' do
      it 'should return the year for a budget title' do
        @subject_instance.year_from_title('2016 Budget').must_equal '2016'
        @subject_instance.year_from_title('BUDGET 2020').must_equal '2020'
      end

      it 'should return the year for an actual title' do
        @subject_instance.year_from_title('2016 actual').must_equal '2016'
        @subject_instance.year_from_title('Actual 2020').must_equal '2020'
      end
    end
  end
end
