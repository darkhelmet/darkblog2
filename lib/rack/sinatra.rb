require 'sinatra/base'

module Rack
  class Sinatra < Sinatra::Base
    def self.call(env)
      status, body, headers = super(env)
      404 == status ? @app.call(env) : [status, body, headers]
    end
  end
end