require_relative 'spec_helper'

include Rack::Test::Methods

def app
  Server
end

describe "my route" do
  it "should display hello world on get root" do
    get '/'
    last_response.body.must_equal 'Hello, World!'
  end
end
