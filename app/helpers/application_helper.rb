module ApplicationHelper
  def content_type_tag
    tag(:meta, 'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8')
  end

  def jquery_tag(version)
    javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js")
  end

  def font_tag(family)
    stylesheet_link_tag("http://fonts.googleapis.com/css?family=#{family}")
  end

  def yield_or_default(key, default)
    content_for?(key) ? content_for(key) : default
  end

  def favicon_tag
    favicon_link_tag('favicon.png', :type => 'image/png')
  end

  def gravatar(size = 120)
    image_tag("http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(Darkblog2.config[:email].strip.downcase)}.png?s=#{size}", :alt => "Gravatar for #{Darkblog2.config[:author]}")
  end

  def description_tag
    tag(:meta, :name => 'description', :content => yield_or_default(:description, Darkblog2.config[:tagline]))
  end

  def title_tag
    content_tag(:title, yield_or_default(:title, Darkblog2.config[:title]))
  end

  def title_text(text)
    "#{text} | #{Darkblog2.config[:title]}"
  end

  def canonical_tag
    tag(:link, :rel => 'canonical', :href => content_for(:canonical)) if content_for?(:canonical)
  end

  def opensearch_tag
    tag(:link, :rel => 'search', :type => 'application/opensearchdescription+xml', :href => opensearch_url, :title => Darkblog2.config[:title])
  end

  def sitemap_tag
    tag(:link, :rel => 'sitemap', :type => 'application/xml', :title => 'Sitemap', :href => sitemap_url)
  end

  def managing_editor
    "#{Darkblog2.config[:email]} (#{Darkblog2.config[:author]})"
  end

  def rss_tag
    auto_discovery_link_tag(:rss, feed_url, :title => "#{Darkblog2.config[:title]} RSS Feed")
  end

  def index_tag
    tag(:link, :rel => 'index', :title => Darkblog2.config[:title], :href => root_url)
  end
end