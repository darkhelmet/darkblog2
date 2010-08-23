module Rack
  class Sinatra
    def initialize(app, sinatra)
      @app = app
      @sinatra = sinatra
    end

    def call(env)
      status, body, headers = @sinatra.call(env)
      404 == status ? @app.call(env) : [status, body, headers]
    end
  end
end