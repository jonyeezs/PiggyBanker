require_relative 'spec_helper'
require 'tilt/erb' # tilt autoloading in a non thread-safe way
require 'base_router'

include Rack::Test::Methods

def app
  BaseRouter
end

describe 'base router' do
  it 'should handle request with OK response' do
    get '/'
    assert_equal last_response.ok?, true
  end

  it 'should handle request leading to 404' do
    get '/fakefakefake'
    assert_equal last_response.status, 404
    last_response.body.must_include '404 PiggyBanker'
  end
end
