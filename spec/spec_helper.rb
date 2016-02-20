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

class SubjectFactory
  def with_module(include_module)
    container = Class.new do
      include include_module
    end
    container.new
  end
end
