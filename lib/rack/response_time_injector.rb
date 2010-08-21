require 'rack/abstract_middleware'

module Rack
  class ResponseTimeInjector < AbstractMiddleware
    def initialize(app, options = {})
      @app = app
      @format = options[:format] || '%f'
    end

    def call(env)
      super(env)
      t0 = Time.now
      status, headers, body = @app.call(env)
      if html?(headers)
        body.each do |part|
          part.gsub!('{{responsetime}}') do
            diff = Time.now - t0
            if @format.respond_to?(:call)
              @format.call(diff)
            else
              @format % diff
            end
          end if part.respond_to?(:gsub!)
        end
        AbstractMiddleware::update_content_length(headers, body)
      end
      [status, headers, body]
    end
  end
end