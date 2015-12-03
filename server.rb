class Server < Sinatra::Base
  set :root, File.dirname(__FILE__)

  def self.initialize
    super
    @version = '0.1'
  end

  configure do
    # Load up database and such
  end

  # Load all route files
  Dir[File.dirname(__FILE__) + '/app/routes/**'].each do |route|
    require route
  end
  # using https://github.com/laser/sinatra-best-practices
  register PiggyBanker::Routing::Menagerie
end
