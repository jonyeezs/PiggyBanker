require_relative '../lib/Creatures'
class Menagerie < Server
  some_creatures = Creatures.new
  get '/:name' do
    content_type :json
    test = "Hello to you #{params[:name]}."
    test += some_creatures.show_creatures
    {
      version: VERSION,
      message: test
    }.to_json
  end
end
