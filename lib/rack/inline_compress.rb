require 'rack/abstract_middleware'

module Rack
  class InlineCompress < AbstractMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      super(env)
      status, headers, body = @app.call(env)
      if html?(headers)
        b = ''
        body.each { |part| b << part.to_s }
        body = pack(Nokogiri(b)).to_s
        AbstractMiddleware::update_content_length(headers, body)
      end
      [status, headers, body]
    end

  private

    def pack(doc)
      pack_script(doc)
      pack_css(doc)
    end

    def pack_css(doc)
      select(doc, 'style').each do |elem|
        elem.inner_html = Rainpress.compress(elem.inner_html)
      end
    end

    def pack_script(doc)
      select(doc, 'script') { |elem| elem.attributes['src'].blank? }.each do |elem|
        elem.inner_html = Packr.pack(elem.inner_html)
      end
    end

    def select(doc, tag)
      elements = doc.search(tag)
      block_given? ? elements.select(&Proc.new) : elements
    end
  end
end