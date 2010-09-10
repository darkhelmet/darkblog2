module Rack
  class CanonicalHost
    def initialize(app, host, port = 80)
      @app = app
      @host = host
      @port = port
    end

    def call(env)
      if url = url(env)
        [301, { 'Location' => url, 'Content-Type' => 'text/html' }, ['Redirecting...']]
      else
        @app.call(env)
      end
    end

  private

    def url(env)
      server = env['SERVER_NAME']
      return if Rails.env.development? || server.match(/localhost|127\.0\.0\.1/) || server == @host
      URI(Rack::Request.new(env).url).tap do |uri|
        uri.host = @host
        uri.port = @port
      end.to_s
    rescue
      nil
    end
  end
end