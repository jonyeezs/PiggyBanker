require_relative 'spec_helper'

describe Spreadsheet::Adapter do
  before do
    fake_session = mock(spreadsheet_by_key: 'some googledrive file object')
    GoogleDrive.stubs(:saved_session).returns(fake_session)
  end

  it 'should initialize with a spreadsheet' do
    subject = Spreadsheet::Adapter.new 'somekey'
    subject.spreadsheet_available?.must_equal true
  end
end
