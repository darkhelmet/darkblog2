xml.instruct!
xml.instruct!('xml-stylesheet', :type => 'text/xsl', :href => "#{root_url}sitemap.xsl")
xml.urlset('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
  xml.url do
    xml.loc(root_url)
    xml.lastmod(@posts.first.published_on.xmlschema)
    xml.changefreq('daily')
    xml.priority(0.5)
  end
  @posts.each do |post|
    xml.url do
      xml.loc(post_permalink(post))
      xml.lastmod(post.updated_at.xmlschema)
      xml.changefreq('monthly')
      xml.priority(1.0)
    end
  end
end