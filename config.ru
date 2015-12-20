require 'rubygems'
require 'bundler'
Bundler.require

require './base_router' # Base route file

# Rack DSL offers a method besides use and run: map.
# This nifty method allows you to map a given path to a Rack endpoint.
# We can use that to serve multiple Sinatra apps from the same process.
# Map MUST be done config.ru.
map('/') { run BaseRouter }

# Load all route files
Dir[File.dirname(__FILE__) + '/app/routes/**.rb'].each do |file_path|
  require file_path
  router_name = File.basename(file_path, '.rb').chomp('_router').classify
  map('/' + router_name.downcase) { run router_name.constantize }
end
