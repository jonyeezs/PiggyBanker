require 'spec_helper'

describe 'Common::WorksheetHelpers' do
  before do
    @subject_instance = SubjectFactory.new.include_module(Common::WorksheetHelpers)
  end

  describe 'Common' do
    # TODO: figure out why this isn't working let(:subject) { Class.new { include WorksheetMapper } }

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
