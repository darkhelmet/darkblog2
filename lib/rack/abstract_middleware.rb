module Rack
  class AbstractMiddleware
    def call(env)
      @env = env
    end

  protected

    class << self
      def update_content_length(headers, body)
        if headers['Content-Length']
          if body.respond_to?(:to_ary)
            headers['Content-Length'] = body.to_ary.inject(0) do |len,part|
              len + Rack::Utils.bytesize(part)
            end.to_s
          end
        end
      end
    end

    def html?(headers)
      headers['Content-Type'].try(:match, /html/)
    end

    def path
      Rack::Utils.unescape(@env['PATH_INFO'])
    end

    def host
      @env['HTTP_HOST']
    end

    def protocol
      @env['rack.url_scheme']
    end
  end
end