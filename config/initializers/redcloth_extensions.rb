require 'RedCloth'

module RedCloth::Formatters::HTML
  def image(opts)
    title = opts[:title]
    opts.delete(:align)
    opts[:alt] = title if title
    img = "<img src=\"#{escape_attribute opts[:src]}\"#{pba(opts)} alt=\"#{escape_attribute opts[:alt].to_s}\" />"
    img = "<a href=\"#{escape_attribute opts[:href]}\">#{img}</a>" if opts[:href]
    img = "#{img}<figcaption style=\"display: none\">#{title}</figcaption>" if title
    "<figure>#{img}</figure>"
  end
end
