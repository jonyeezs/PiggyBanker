require 'rubygems'
require 'bundler'
Bundler.require

require './server' # Base route file

# Map MUST be done config.ru
map('/') { run Server }

# Load all route files
Dir[File.dirname(__FILE__) + '/app/routes/**.rb'].each do |file_path|
  require file_path
  file_name = File.basename(file_path, '.rb').chomp('Router').classify
  map('/' + file_name.downcase) { run file_name.constantize }
end
