class CacheWiper < ActiveModel::Observer
  observe :post

  def after_save(post)
    Rails.cache.clear if post.published?
  end
end
