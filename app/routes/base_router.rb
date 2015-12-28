require 'date'

class BaseRouter < Sinatra::Base
  set :root, PiggyBanker.root
  set :public_folder, settings.root + PiggyBanker.settings['assetspath']

  def respond_with(content = nil)
    response = {
      version:   "#{PiggyBanker.settings['version']}",
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
