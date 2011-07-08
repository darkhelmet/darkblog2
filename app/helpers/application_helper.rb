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
    favicon_link_tag('favicon.png', type: 'image/png')
  end

  def apple_touch_icon_tag
    tag(:link, rel: 'apple-touch-icon', href: 'http://www.gravatar.com/avatar/48409ce1953c290351fcb875b20eccbb.png?s=114')
  end

  def gravatar(size = 120)
    image_tag("http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(Darkblog2.config[:email].strip.downcase)}.png?s=#{size}", alt: "Gravatar for #{Darkblog2.config[:author]}")
  end

  def description_tag
    tag(:meta, name: 'description', content: yield_or_default(:description, Darkblog2.config[:tagline]))
  end

  def readability_tag
    tag(:meta, name: 'readability-verification', content: 'ee3QxRba5qSzvNEXBLAgbYCyCMTqMkkmJQrhvQKs')
  end

  def title_tag
    content_tag(:title, yield_or_default(:title, Darkblog2.config[:title]))
  end

  def title_text(text)
    "#{text} | #{Darkblog2.config[:title]}"
  end

  def canonical_tag
    tag(:link, rel: 'canonical', href: content_for(:canonical)) if content_for?(:canonical)
  end

  def opensearch_tag
    tag(:link, rel: 'search', type: 'application/opensearchdescription+xml', href: opensearch_url, title: Darkblog2.config[:title])
  end

  def sitemap_tag
    tag(:link, rel: 'sitemap', type: 'application/xml', title: 'Sitemap', href: sitemap_url)
  end

  def managing_editor
    "#{Darkblog2.config[:email]} (#{Darkblog2.config[:author]})"
  end

  def rss_tag
    auto_discovery_link_tag(:rss, feed_url, title: "#{Darkblog2.config[:title]} RSS Feed")
  end

  def index_tag
    tag(:link, rel: 'index', title: Darkblog2.config[:title], href: root_url)
  end

  def post_link(post)
    link_to(post.title, post_permalink(post), rel: 'bookmark')
  end

  def tag_link(tag)
    link_to(tag.downcase, tag_url(tag), rel: 'tag')
  end

  def inline?
    @inline ||= !params[:inline].to_i.zero?
  end

  def show_ads?
    !ENV['SHOW_ADS'].blank?
  end

  def render_social_links
    header_icons = {
      twitter: {
        link: 'http://twitter.com/darkhelmetlive',
        title: 'Follow me on Twitter'
      },
      linkedin: {
        link: 'http://ca.linkedin.com/in/darkhelmetlive',
        title: 'Connect with me on Linkedin'
      },
      skype: {
        link: 'skype:darkhelmetlive?call',
        title: 'Call on me! Call me! Call on me! Call me...on Skype'
      },
      flickr: {
        link: 'http://www.flickr.com/photos/darkhelmetlive/',
        title: 'My pictures on Flickr'
      },
      github: {
        link: 'https://github.com/darkhelmet',
        title: 'My codez on teh Githubz'
      },
      gplus: {
        link: 'http://gplus.to/darkhelmetlive',
        title: 'Add me to a Circle on Google+'
      },
      rss: {
        link: feed_path,
        title: 'Get new articles in your RSS reader'
      }
    }
    [:twitter, :gplus, :linkedin, :skype, :github, :flickr, :rss].each do |icon|
      data = header_icons[icon]
      concat(link_to(image_tag("icons/#{icon}.png", alt: "#{icon.to_s.capitalize} Icon", height: 28, width: 28, grayscale: image_path("icons/#{icon}_grayscale.png")), data[:link], title: data[:title], :class => icon))
    end
  end
end