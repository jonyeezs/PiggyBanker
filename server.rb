require 'date'

class Server < Sinatra::Base
  set :root, File.dirname(__FILE__)
  VERSION = '0.1'
  configure do
    # Load up database and such
  end

  def response_with(content = nil)
    response = {
      version:   VERSION,
      timestamp: Time.now.to_s
    }
    response[:content] = content unless content.nil?
    response.to_json
  end

  get '/' do
    response_with ruby: RUBY_VERSION, message: 'hello world!'
  end

  not_found do
    status 404
    erb :error
  end
end
