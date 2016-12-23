require 'spec_helper'
require 'lib/data_mappers/budget'
require 'lib/data_mappers/mappers/google_drive'

describe DataMappers::Budget do
  before do
    first = Object.new
    def first.title
      'budget 2016'
    end
    second = Object.new
    def second.title
      'somethingelse 2016'
    end
    mock_tables = [first, second]
    mock_connector = Object.new
    mock_connector.stubs(:tables).returns mock_tables
    DataMappers::Connectors::GoogleDriveConnector.stubs(:new).returns(mock_connector)
    DataMappers::Mappers::GoogleDrive.stubs(:map_article).returns('article')
    @subject = DataMappers::Budget.new
  end

  describe 'budgets' do
    it 'should only look for tables with budget in title' do
      # FIXME: mock(DataMappers::Mappers::GoogleDrive).expects(:map_article).at_most_once
      @subject.articles
    end
  end
end
