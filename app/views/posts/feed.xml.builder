xml.instruct!
xml.rss(:version => "2.0") do
  xml.channel do
    xml.title(Darkblog2.config[:title])
    xml.link(root_url)
    xml.description(Darkblog2.config[:tagline])
    xml.language('en-us')
    xml.managingEditor(managing_editor)
    xml.webMaster(managing_editor)
    xml.lastBuildDate(@posts.first.published_on.to_s(:rss))
    @posts.each do |post|
      xml.item do
        xml.title(post.title)
        xml.category(post.category.capitalize)
        xml.pubDate(post.published_on.to_s(:rss))
        xml.link(post_permalink(post))
        xml.guid(post_permalink(post))
        xml.author(managing_editor)
        xml.description do
          xml.cdata!(post.body_html)
        end
      end
    end
  end
end