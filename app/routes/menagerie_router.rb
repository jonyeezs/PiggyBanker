require_relative '../services/Creatures'

class Menagerie < BaseRouter
  some_creatures = Creatures.new
  get '/:name' do
    content_type :json
    test = "Hello to you #{params[:name]}. "
    test += some_creatures.show_creatures
    respond_with message: test
  end
end
