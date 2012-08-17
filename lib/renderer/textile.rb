module Renderer
  class Textile < RedCloth::TextileDoc
    include Images

    DefaultRules = [:parse_images]

    module HTMLRenderer
      include RedCloth::Formatters::HTML

      def image(opts)
        cls = opts[:class].to_s
        if match = opts[:src].match(Images::SizeRegex)
          cls += " #{match[:size]}"
        end
        super(opts.merge(:class => cls))
      end
    end

    attr_reader :image_hash

    def initialize(template, image_hash)
      super(template)
      @image_hash = image_hash
    end

    def to_html(*rules)
      rules |= DefaultRules
      apply_rules(rules)
      to(HTMLRenderer)
    end
  end
end
