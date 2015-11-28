class Server < Sinatra::Base
  get '/' do
    'Hello, World!'
  end

  get '/hello/:name' do
    @test = "Hello to you #{params[:name]}.<br>"
    some_movie = Creatures.new
    @test += some_movie.show_creatures
    @test
  end

  get '/hellomother' do
    some_movie = Creatures.new
    some_movie.declare_my_animal
  end

  not_found do
    status 404
    erb :error
  end
end
