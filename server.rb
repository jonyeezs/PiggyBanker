class Server < Sinatra::Base
  set :root, File.dirname(__FILE__)
  VERSION = '0.1'
  configure do
    # Load up database and such
  end

  get '/' do
    { version: VERSION }.to_json
  end

  not_found do
    status 404
    erb :error
  end
end
