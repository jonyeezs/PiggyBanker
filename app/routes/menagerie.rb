require_relative '../lib/Creatures'
module PiggyBanker
  module Routing
    module Menagerie
      def self.registered(app)
        some_creatures = Creatures.new
        app.get '/' do
          'Hello, World!'
        end
        app.get '/hello/:name' do
          content_type :json
          test = "Hello to you #{params[:name]}.<br>"
          test += some_creatures.show_creatures
          {
            version: @version,
            message: test
          }.to_json
        end
        app.not_found do
          status 404
          erb :error
        end
      end
    end
  end
end
