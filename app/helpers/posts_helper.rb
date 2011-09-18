module PostsHelper
  def category_link(category)
    link_to(category.capitalize, category_path(category))
  end

  def monthly_archive_link(str)
    year, month = Date.parse(str).strftime('%Y-%m').split('-')
    link_to(str, monthly_path(year, month))
  end

  def post_permalink(post, *args)
    year, month, day = post.published_on.strftime('%Y-%m-%d').split('-')
    permalink_url(year, month, day, post.slug, *args)
  end

  def title_for(post)
    "#{post.title} | #{Darkblog2.config[:title]}"
  end

  def render_updated_at(post)
    content_tag(:time, post.published_on.to_s(:post), :class => 'updated', datetime: post.published_on.xmlschema, pubdate: '')
  end

  def image_for(post)
    body_image = Nokogiri(post.body_html).search('img').first
    body_image.nil? ? gravatar_url : body_image[:src]
  end
end
