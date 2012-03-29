class PostSweeper < ActionController::Caching::Sweeper
  observe :post

  def after_save(post)
    expire_cache(post) if post.public?
  end

  def after_destroy(post)
    expire_cache(post)
  end

private

  def expire_cache(post)
    day, month, year = post.published_on.to_s(:split).split('/')

    expire_action('main')
    expire_action(category_path(post.category))
    expire_action(monthly_path(year: year, month: month))
    expire_action(permalink_path(year: year, month: month, day: day, slug: post.slug))
    expire_tags(post.tags)
    expire_archives
  end

  def expire_archives
    PostsController::Archives.keys.each do |archive|
      expire_action(archive_path(archive))
    end
  end

  def expire_tags(tags)
    Array(tags).each do |tag|
      expire_action(tag_path(tag))
    end
  end
end
