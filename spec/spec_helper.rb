ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.require :default, :test

require_relative '../server'

# Some Helper mock classes you can use
class MockWorksheet # Implementation simplified from GoogleDrive::Worksheet
  attr_accessor :title
  def initialize
    @cells = {}
    @title = 'fake file'
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
  def with_module(include_module)
    container = Class.new do
      include include_module
    end
    container.new
  end
end
