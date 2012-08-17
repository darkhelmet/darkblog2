class PostDecorator < ApplicationDecorator
  decorates :post

  def body_html
    case renderer
    when 'textile'
      Renderer::Textile.new(body, image_hash).to_html
    when 'markdown'
      Renderer::Markdown.new(body, image_hash).to_html
    else
      fail "Invalid renderer: #{renderer}"
    end
  end

  def image_hash
    images.group_by do |image|
      File.basename(image, File.extname(image)).parameterize.to_s.gsub('-', '_')
    end.reduce({}) do |hash, (key, sizes)|
      urls = hashmap(sizes.index_by { |size| size.split('/')[2] }) do |size, path|
        h.image_path(path)
      end
      hash.merge!(key => urls)
    end
  end

  def category_link
    h.link_to(category.humanize, h.category_path(category))
  end

  def permalink(*args)
    year, month, day = published_on.strftime('%Y-%m-%d').split('-')
    h.permalink_url(year, month, day, slug, *args)
  end

  def link
    h.link_to(title, permalink, rel: 'bookmark')
  end

  def author
    Darkblog2.config.author
  end

  def main_title
    h.title_text(title)
  end

  def human_category
    category.humanize
  end

  def published_on_schema
    published_on.xmlschema
  end

  def published_on_post
    published_on.to_s(:post)
  end

  def published_on_rss
    published_on.to_s(:rss)
  end

  def published_on_time_ago_in_words
    h.time_ago_in_words(post.published_on)
  end

  def updated_at_schema
    updated_at.xmlschema
  end

  def meta_time
    h.content_tag(:time, published_on_post, datetime: published_on_schema)
  end

  def updated_at_time
    h.tag(:time, :class => 'updated', datetime: updated_at.xmlschema, style: 'display: none')
  end

  def image_for
    body_image and body_image[:src] or h.gravatar_url
  end

  def truncated_body_html(length = 450)
    h.truncate(h.strip_tags(body_html), :length => length)
  end

private

  def body_image
    Nokogiri(body_html).search('img').first
  end

  def hashmap(hash)
    hash.reduce({}) do |hash, (key, value)|
      hash.merge!(key => yield(key, value))
    end
  end
end
