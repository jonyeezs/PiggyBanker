ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/mini_test'
require 'sinatra/base'
require 'rack/test'
require 'active_support/all'
require_relative '../server'

# Load all files to test
Dir[File.expand_path('..') + '/app/**/*.rb'].each do |file|
  require file
end

# Some Helper mock classes you can use
class MockWorksheet # Implementation simplified from GoogleDrive::Worksheet
  attr_writer :rows_count
  def initialize
    @cells = {}
  end

  def num_rows
    @rows_count
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

class SubjectFactory
  def with_module(include_module)
    container = Class.new do
      include include_module
    end
    container.new
  end
end
