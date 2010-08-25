require 'rack/abstract_middleware'

module Rack
  class RemoveSlash < AbstractMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      super(env)
      if trailing_slash?
        [
          301,
          { 'Location' => "#{protocol}://#{host}#{path.gsub(/\/+$/,'')}", 'Content-Type' => 'text/html' },
          ['A trailing slash? Really?']
        ]
      else
        @app.call(env)
      end
    end

  private

    def trailing_slash?
      '/' != path && '/' == path[-1,1]
    end
  end
end