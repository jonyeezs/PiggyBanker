source 'https://rubygems.org'
ruby '2.1.7'

gem 'sinatra', require: 'sinatra/base'
gem 'thin'
gem 'activesupport', '~> 4.2', '>= 4.2.5', require: 'active_support/all'
gem 'json'
gem 'google_drive'

# http://bundler.io/groups.html
# group :development do
# end

group :test do
  gem 'rake', require: 'rake/testtask'
  gem 'rack-test', require: 'rack/test'
  gem 'minitest', require: ['minitest/autorun', 'minitest/spec']
  gem 'mocha', require: 'mocha/mini_test'
end
