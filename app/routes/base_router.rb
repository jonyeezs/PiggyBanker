require 'date'

class BaseRouter < Sinatra::Base
  set :root, PiggyBanker.root
  set :public_folder, settings.root + PiggyBanker.settings['assetspath']

  get '/' do
    respond_with ruby: RUBY_VERSION
  end

  not_found do
    status 404
    erb :error
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
