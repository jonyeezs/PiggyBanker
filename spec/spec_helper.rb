ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'mocha/mini_test'
require 'sinatra/base'
require 'rack/test'
require 'active_support/all'
require_relative '../server'

# Load all files to test
Dir[File.expand_path('..') + '/app/**/*.rb'].each do |file|
  puts file
  require file
end
