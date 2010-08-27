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

  def favicon_tag(path)
    tag(:link, :rel => 'icon', :type => 'image/png', :href => path)
  end

  def gravatar(email, size = 120)
    image_tag("http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}.png?s=#{size}", :alt => 'Gravatar for Daniel Huckstep')
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
end