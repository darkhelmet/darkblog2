Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY'] || ENV['HOPTOAD_API_KEY']
end

# Move the Hoptoad middleware WAY up the stack.
Rails.application.config.middleware.tap do |mw|
  mw.delete(Airbrake::Rack)
  mw.insert_before(Rack::Gist, Airbrake::Rack)
end
