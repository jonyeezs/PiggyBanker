require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

require './server'

run PiggyBanker.app
