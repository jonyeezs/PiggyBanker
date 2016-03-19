ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.require :default, :test

## PiggyBanker's settings
# TODO: how do i really mock this...
module PiggyBanker
  def self.root
    'root\dir'
  end

  def self.settings
    {
      'spreadsheet_key'      => 'somekey',
      'googledrive_settings' => 'sakdjisdsalsadkjsaj',
      'assetspath'           => 'path_to_my_assets',
      'version'              => 'v.test'
    }
  end
end

# Some Helper mock classes you can use
class MockWorksheet # Implementation simplified from GoogleDrive::Worksheet
  attr_accessor :title
  def initialize
    @cells = {}
    @title = 'budget 1984'
  end

  def num_rows
    @cells.length
  end

  def [](*args)
    row = args[0]
    col = args[1]
    @cells[[row, col]] || ''
  end

  def []=(*args)
    row = args[0]
    values = args[-1]
    values.each_index do |i|
      @cells[[row, i + 1]] = values[i]
    end
  end
end

class MockSpreadSheet
  attr_accessor :worksheets
  def initialize(worksheets)
    @worksheets = worksheets
  end
end

class SubjectFactory
  def include_module(moduleName)
    container = Class.new do
      include moduleName
    end
    container.new
  end
end
