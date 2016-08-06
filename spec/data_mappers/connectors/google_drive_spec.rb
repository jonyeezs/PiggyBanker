require 'spec_helper'
require 'lib/data_mappers/connectors/google_drive'
require 'lib/data_mappers/connectors/models/google_drive'
require 'google_drive'

describe DataMappers::Connectors::GoogleDriveConnector do
  describe 'without key' do
    it 'should raise an exception when no key is given' do
      assert_raises ArgumentError do
        _subject = DataMappers::Connectors::GoogleDriveConnector.new
      end
    end
  end
  describe 'with key' do
    before do
      @fake_session = mock('object')
      @fake_spreadsheet = mock('GoogleDrive::Spreadsheet')
      GoogleDrive.stubs(:saved_session).returns(@fake_session)
      @fake_session.expects(:spreadsheet_by_key).returns(@fake_spreadsheet)
    end

    it 'should initialize with a spreadsheet' do
      DataMappers::Connectors::GoogleDriveConnector.new 'somekey'
    end

    describe 'tables' do
      it 'should return the available worksheets' do
        @fake_spreadsheet.expects(:worksheets).once
        subject = DataMappers::Connectors::GoogleDriveConnector.new 'somekey'
        subject.tables
      end
    end

    describe 'update' do
      before do
        @mocked_worksheet = mock('GoogleDrive::Worksheet')
        @budget_title = 'title name must be exact'
        @mocked_worksheet.stubs(:title).returns(@budget_title)
        not_the_droid = mock('GoogleDrive::Worksheet')
        not_the_droid.stubs(:title).returns('carry on')
        @fake_spreadsheet.stubs(:worksheets).returns(
          [
            not_the_droid,
            @mocked_worksheet
          ])
      end
      it 'should update the corresponding worksheet the correct items' do
        cells =
        [
          DataMappers::Connectors::Model::GoogleDrive::Cell.new(1, 1, 'first'),
          DataMappers::Connectors::Model::GoogleDrive::Cell.new(1, 2, 'second')
        ]
        worksheet = DataMappers::Connectors::Model::GoogleDrive::Worksheet.new @budget_title, cells
        @mocked_worksheet.expects(:[]=).times(2)
        @mocked_worksheet.expects(:save).once
        subject = DataMappers::Connectors::GoogleDriveConnector.new 'somekey'
        subject.update worksheet
      end
    end
  end
end
