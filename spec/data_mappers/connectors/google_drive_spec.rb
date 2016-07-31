require 'spec_helper'
require 'lib/data_mappers/connectors/google_drive'

describe DataMappers::Connectors::GoogleDrive do
  describe 'without key' do
    it 'should raise an exception when no key is given' do
      assert_raises ArgumentError do
        _subject = DataMappers::Connectors::GoogleDrive.new
      end
    end
  end
  describe 'with key' do
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
      WorksheetMapper.stubs(:map_article).returns('someobject')
      @spreadsheet = MockSpreadSheet.new @worksheets
      @fake_session = mock(spreadsheet_by_key: @spreadsheet)
      GoogleDrive.stubs(:saved_session).returns(@fake_session)
    end

    it 'should initialize with a spreadsheet' do
      subject = DataMappers::Connectors::GoogleDrive.new 'somekey'
      assert subject.tables.length > 0
    end
  end
end
