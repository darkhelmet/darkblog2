module Renderer
  class Markdown < Struct.new(:template, :image_hash)
    include Images

    def to_html
      md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, space_after_headers: true, tables: true, no_intra_emphasis: true, strikethrough: true)
      parse_images(template)
      md.render(template)
    end
  end
end
