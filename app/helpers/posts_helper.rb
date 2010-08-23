module PostsHelper
  def post_permalink(post)
    year, month, day = post.published_on.strftime('%Y-%m-%d').split('-')
    permalink_path(year, month, day, post.slug)
  end
end
