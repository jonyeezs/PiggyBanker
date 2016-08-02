require 'spec_helper'
require 'lib/data_mappers/connectors/google_drive'

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
      GoogleDrive.stubs(:saved_session).returns(@fake_session)
      @fake_session.expects(:spreadsheet_by_key)
    end

    it 'should initialize with a spreadsheet' do
      DataMappers::Connectors::GoogleDriveConnector.new 'somekey'
    end
  end
end
