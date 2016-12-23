require 'spec_helper'
require 'lib/data_mappers/mappers/google_drive'

describe DataMappers::Mappers::GoogleDrive do
  before do
    @worksheet = MockWorksheet.new
  end

  describe 'map_article' do
    before do
      DataMappers::Mappers::GoogleDrive::MapToArticleHelper.any_instance.stubs(:year_from_title).returns('year')
      DataMappers::Mappers::GoogleDrive::MapToArticleHelper.any_instance.stubs(:get_items).returns([])
      @result = DataMappers::Mappers::GoogleDrive.map_article @worksheet
    end
    it 'should map to article object' do
      @result.year.must_equal 'year'
      assert @result.is_a? Model::Article
    end
  end
  describe 'map_worksheet_with_new_cells' do
    before do
      debit_item = Model::Budget::Item.new description: 'debit item', id: 8,
                                  occurance: :daily, amount: 4.12
      debit_item2 = Model::Budget::Item.new description: 'debit item2', id: 10,
                                  occurance: :daily, amount: 5.00
      credit_item = Model::Budget::Item.new description: 'credit item', id: 14,
                                  occurance: :daily, amount: (-2.00)
      credit_item2 = Model::Budget::Item.new description: 'credit item2', id: 16,
                                  occurance: :daily, amount: (-3.33)
      @article = Model::Article.new '2016', [debit_item, credit_item, debit_item2, credit_item2]
    end

    it 'should map an article to a worksheet with cells populated for a new debit item' do
      new_item = { 'amount' => 11, 'occurance' => :daily, 'description' => 'new' }
      @result = DataMappers::Mappers::GoogleDrive.map_worksheet_with_new_cells @article, new_item
      assert @result.is_a? DataMappers::Connectors::Model::GoogleDrive::Worksheet
      @result.cells.length.must_equal 4
      @result.cells[0].row.must_equal 10
    end

    it 'should map an article to a worksheet with cells populated for a new crebit item' do
      new_item = { 'amount' => (-12), 'occurance' => :daily, 'description' => 'new' }
      @result = DataMappers::Mappers::GoogleDrive.map_worksheet_with_new_cells @article, new_item
      assert @result.is_a? DataMappers::Connectors::Model::GoogleDrive::Worksheet
      @result.cells.length.must_equal 4
      @result.cells[0].row.must_equal 16
    end
  end

  describe 'MapToArticleHelper' do
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
      @subject_instance = DataMappers::Mappers::GoogleDrive::MapToArticleHelper.new
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

  describe 'MapToWorksheetHelper' do
    before do
      @items = [{
        'id'          => 1,
        'description' => 'debit item',
        'category'    => 'payday',
        'occurance'   => 'daily',
        'amount'      => 4.12
      }, {
        'id'          => 2,
        'description' => 'credit item',
        'category'    => 'bill',
        'occurance'   => 'monthly',
        'amount'      => -4.12
      }]
      @subject_instance = DataMappers::Mappers::GoogleDrive::MapToWorksheetHelper.new
    end
    describe 'budget_title_from_year' do
      it 'should add the word budget to the year' do
        @subject_instance.budget_title_from_year('2016').must_equal 'Budget 2016'
      end
    end

    describe 'hash_to_cells' do
      it 'should convert hashes into cells' do
        results = @subject_instance.hash_to_cells(@items[0])
        results.length.must_equal 4
        results.each do |cell|
          cell.must_be_instance_of DataMappers::Connectors::Model::GoogleDrive::Cell
          cell.row.must_equal @items[0]['id']
        end
      end
      it 'should map the item fields to the appropriate column' do
        results = @subject_instance.hash_to_cells(@items[0])
        results[0].value.must_equal @items[0]['description']
        results[0].column.must_equal 1
        results[1].value.must_equal @items[0]['category']
        results[1].column.must_equal 2
        results[2].value.must_equal @items[0]['occurance']
        results[2].column.must_equal 3
        results[3].value.must_equal @items[0]['amount']
        results[3].column.must_equal 4
      end
    end

    describe 'get_worksheet' do
      it 'should map article to googledrive model' do
        result = @subject_instance.get_worksheet 2016, @items
        result.must_be_instance_of DataMappers::Connectors::Model::GoogleDrive::Worksheet
        result.cells.length.must_equal 8
      end
    end
  end
end
