module PostsHelper
  def category_link(category)
    link_to(category.capitalize, category_path(category))
  end

  def monthly_archive_link(str)
    year, month = Date.parse(str).strftime('%Y-%m').split('-')
    link_to(str, monthly_path(year, month))
  end

  def post_permalink(post)
    year, month, day = post.published_on.strftime('%Y-%m-%d').split('-')
    permalink_path(year, month, day, post.slug)
  end

  def title_for(post)
    "#{post.title} | #{Darkblog2.config[:title]}"
  end
end