ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'sinatra/base'
require 'rack/test'

# Load all files to test
Dir[File.expand_path('..') + '/app/**/*.rb'].each do |file|
  require file
end
