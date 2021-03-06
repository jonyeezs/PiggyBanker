require 'yaml'

# For settings, trying to follow this:
# http://stackoverflow.com/questions/14846031/universal-settings-in-sinatra

module PiggyBanker
  def self.settings
    @app_config ||= YAML.load_file(@root + '/config/appConfig.yml')
  end

  def self.root
    @root = File.dirname(__FILE__)
  end

  def self.app
    Server.new do
      load_paths '/app'
      map_base_route
      map_routes
    end
  end

  class Server < Rack::Builder
    def load_paths(foldername)
      $LOAD_PATH << File.join(PiggyBanker.root, foldername)
    end

    def map_routes
      # Refer to: https://www.safaribooksonline.com/library/view/sinatra-up-and/9781449306847/ch04.html
      # Rack DSL offers a method besides use and run: map.
      # This nifty method allows you to map a given path to a Rack endpoint.
      # We can use that to serve multiple Sinatra apps from the same process
      Dir[File.dirname(__FILE__) + '/app/routes/**.rb'].each do |file_path|
        next if file_path.include? 'base_router'
        require file_path
        router_name = File.basename(file_path, '.rb').chomp('_router').capitalize
        map('/' + router_name.downcase) { run router_name.constantize }
      end
    end

    private

    def map_base_route
      require_relative PiggyBanker.root + '/app/routes/base_router'
      map('/') { run BaseRouter }
    end
  end
end
