require 'sinatra/base'

module Rack
  class Sinatra < Sinatra::Base
    def call(env)
      status, body, headers = super(env)
      404 == status ? @app.call(env) : [status, body, headers]
    end

    def self.call(env)
      (@@sinatra ||= self.new).call(env)
    end
  end
end