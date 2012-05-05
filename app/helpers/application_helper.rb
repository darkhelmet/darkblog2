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
    tag(:link, rel: 'apple-touch-icon', href: gravatar_url(114))
  end

  def gravatar_url(size = 120)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(Darkblog2.config.email.strip.downcase)}.png?s=#{size}"
  end

  def gravatar(size = 120)
    image_tag(gravatar_url(size), alt: "Gravatar for #{Darkblog2.config.author}")
  end

  def description_tag
    tag(:meta, name: 'description', content: yield_or_default(:description, Darkblog2.config.tagline))
  end

  def readability_tag
    tag(:meta, name: 'readability-verification', content: 'ee3QxRba5qSzvNEXBLAgbYCyCMTqMkkmJQrhvQKs')
  end

  def title_tag
    content_tag(:title, yield_or_default(:title, Darkblog2.config.title))
  end

  def title_text(text)
    "#{text} | #{Darkblog2.config.title}"
  end

  def canonical_tag
    tag(:link, rel: 'canonical', href: content_for(:canonical)) if content_for?(:canonical)
  end

  def opensearch_tag
    tag(:link, rel: 'search', type: 'application/opensearchdescription+xml', href: opensearch_url, title: Darkblog2.config.title)
  end

  def sitemap_tag
    tag(:link, rel: 'sitemap', type: 'application/xml', title: 'Sitemap', href: sitemap_url)
  end

  def open_graph_tag(name, content)
    tag(:meta, :property => "og:#{name}", :content => content)
  end

  def managing_editor
    "#{Darkblog2.config.email} (#{Darkblog2.config.author})"
  end

  def rss_tag
    auto_discovery_link_tag(:rss, feed_url, title: "#{Darkblog2.config.title} RSS Feed")
  end

  def index_tag
    tag(:link, rel: 'index', title: Darkblog2.config.title, href: root_url)
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
    {
      twitter: {
        link: 'http://twitter.com/darkhelmetlive',
        title: 'Follow me on Twitter',
        text: 'Twitter',
        icon: 'T'
      },
      gplus: {
        link: 'https://plus.google.com/107826869818581440524?rel=author',
        title: 'Add me to a Circle on Google+',
        text: 'Google+',
        icon: '+'
      },
      skype: {
        link: 'skype:darkhelmetlive?call',
        title: 'Call on me! Call me! Call on me! Call me...on Skype',
        text: 'Skype',
        icon: 'S'
      },
      github: {
        link: 'https://github.com/darkhelmet',
        title: 'My codez on teh Githubz',
        text: 'GitHub',
        icon: 'G'
      },
      flickr: {
        link: 'http://www.flickr.com/photos/darkhelmetlive/',
        title: 'My pictures on Flickr',
        text: 'Flickr',
        icon: 'F'
      },
      rss: {
        link: feed_path,
        title: 'Get new articles in your RSS reader',
        text: 'RSS',
        icon: 'R'
      }
    }.each do |icon, data|
      concat(link_to(data[:icon], data[:link], title: data[:title], icon: data[:icon], :class => 'icon'))
    end
  end

  def license_image
    link_to(image_tag('license.png', alt: 'Creative Commons License'), 'http://creativecommons.org/licenses/by-sa/2.5/ca/', no_escape: true, rel: 'license')
  end

  def license_link
    link_to('Creative Commons Licence', 'http://creativecommons.org/licenses/by-sa/2.5/ca/')
  end
end