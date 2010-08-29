# Move the Hoptoad middleware WAY up the stack.
Rails.application.config.middleware.tap do |mw|
  mw.delete(HoptoadNotifier::Rack)
  mw.insert_before(Rack::Sinatra, HoptoadNotifier::Rack)
end

HoptoadNotifier.configure do |config|
  config.api_key = ENV['HOPTOAD_API_KEY']
end
