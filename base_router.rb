require 'date'

class BaseRouter < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :public_folder, settings.root + '/assets'

  VERSION = '0.1'

  configure do
    # Load up database and such
  end

  def respond_with(content = nil)
    response = {
      version:   VERSION,
      timestamp: Time.now.to_s
    }
    response[:content] = content unless content.nil?
    response.to_json
  end

  get '/' do
    respond_with ruby: RUBY_VERSION
  end

  not_found do
    status 404
    erb :error
  end
end
