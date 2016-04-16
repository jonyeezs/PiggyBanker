# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

guard 'rack', port: 9292 do
  watch('Gemfile.lock')
  watch('config.ru')
  watch('server.rb')
  watch(%r{^config/.*})
  watch(%r{^app/(?!routes)([a-zA-Z]+)/.*}) # routes will be watched by sinatra::reloader
end
