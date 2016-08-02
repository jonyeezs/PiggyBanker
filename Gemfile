# http://bundler.io/groups.html
source 'https://rubygems.org'
ruby '2.1.7'

gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-cross_origin'
gem 'thin'
gem 'activesupport', '~> 4.2', '>= 4.2.5', require: 'active_support/all'
gem 'json'
gem 'google_drive', '~> 1.0.6'

# TODO: look into a debugging tool
group :development do
  gem 'sinatra-contrib'
  gem 'wdm', '>= 0.1.0' if Gem.win_platform?
  # gem 'guard'
  # gem 'guard-rack'
  # gem 'rerun' works only on Unix
end

# Interesting stats on most popular framework https://www.ruby-toolbox.com/categories/testing_frameworks.html
group :test do
  gem 'rake', require: 'rake/testtask'
  gem 'rack-test', require: 'rack/test'
  # TODO: Read these about minitest and then clean up yours
  # 1. http://chriskottom.com/blog/2014/06/dress-up-your-minitest-output/
  # 2. https://launchschool.com/blog/implement-minitest-from-scratch-and-learn-from-it
  # 3. http://chriskottom.com/blog/2014/10/4-fantastic-ways-to-set-up-state-in-minitest/
  gem 'minitest', require: ['minitest/autorun', 'minitest/spec']
  gem 'minitest-stub-const'
  gem 'mocha', require: 'mocha/mini_test'
end
