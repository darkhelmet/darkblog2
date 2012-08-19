module Rack
  class Block < Sinatra::Base
    Middleware = Class.new do
      def initialize(app)
        @app = app
        @blocker = ::Rack::Block.new
      end

      def call(env)
        status, headers, body = @blocker.call(env)
        404 == status ? @app.call(env) : [status, headers, body]
      end
    end

    get '/opensearch.xml' do
      halt 404 # This one is fine
    end

    get %r{\.(php|xml|exe|asp)$} do
      halt 403, 'No, Mr. Superman no here...'
    end
  end
end
