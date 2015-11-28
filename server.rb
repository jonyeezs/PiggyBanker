class Server < Sinatra::Base
  configure do
    # Load up database and such
  end
end

# Load all route files
Dir[File.dirname(__FILE__) + '/app/routes/**'].each do |route|
  require route
end

# Load all modules
Dir[File.dirname(__FILE__) + '/app/modules/**'].each do |appmodule|
  require appmodule
end
