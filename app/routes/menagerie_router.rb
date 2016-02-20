require_relative '../lib/Creatures'

class Menagerie < BaseRouter
  some_creatures = Creatures.new
  get '/:name' do
    test = "Hello to you #{params[:name]}. "
    test += some_creatures.show_creatures
    respond_with message: test
  end
end
