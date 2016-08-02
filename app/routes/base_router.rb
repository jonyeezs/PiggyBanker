require 'date'
require 'sinatra/cross_origin'

class BaseRouter < Sinatra::Base
  configure do
    register Sinatra::CrossOrigin
    enable :cross_origin
  end

  set :root, PiggyBanker.root
  set :public_folder, settings.root << PiggyBanker.settings['assetspath']

  not_found do
    status 404
    # erb :error # FIXME: how to stub erb
  end

  def respond_with(content = nil)
    content_type :json
    response = {
      version:   "#{PiggyBanker.settings['version']}",
      timestamp: Time.now.to_s
    }
    response[:content] = content unless content.nil?
    response.to_json
  end

  def response_internal_error
    status 500
  end

  def response_not_found
    status 404
  end
end
