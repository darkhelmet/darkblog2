class PostsController < CachedController
  respond_to :html, :json, :js

  Archives = {
    'full' => 'full',
    'category' => 'category',
    'month' => 'month'
  }

  def main
    respond_with(@posts = decorate(Post.find_for_main_page))
  end

  def permalink
    post = Post.find_by_permalink_params(params)
    render_404 and return unless post.present?
    redirect_to_post(post) and return if post.slug != params[:slug]
    respond_with(@post = decorate(post)) if stale?(post, :public => true)
  end

  def category
    # TODO: Find latest updated in category for `stale?` check
    posts = Post.find_by_category(params[:category])
    render_404 and return if posts.empty?
    respond_with(@posts = decorate(posts))
  end

  def archive
    archive = Archives.fetch(params[:archive], 'full')
    render(action: "archive_#{archive}")
  end

  def monthly
    # TODO: Find latest updated in month for `stale?` check
    posts = Post.find_by_month(params)
    render_404 and return if posts.empty?
    respond_with(@posts = decorate(posts))
  end

  def sitemap
    @posts = decorate(Post.publish_order.all)
  end

  def search
    respond_with(@posts = decorate(Post.search_by_keywords(params[:query])))
  end

  def feed
    expires_now
    unless Rails.env.development? || user_agent?(/feedburner/i) || params[:no_fb]
      redirect_to(feedburner_url, status: :moved_permanently) and return
    end
    request.headers['Content-Type'] = 'application/rss+xml; charset=utf-8'
    @posts = decorate(Post.publish_order.limit(10))
  end

  def tag
    # TODO: Find latest updated in tag for `stale?` check
    tag = params[:tag].strip.parameterize
    respond_with(@posts = decorate(Post.find_by_tag(tag)))
  end

private

  def user_agent?(ua)
    request.user_agent.to_s.match(ua)
  end

  def feedburner_url
    "http://feeds.feedburner.com/#{Darkblog2.config.feedburner}"
  end

  def redirect_to_post(post)
    year, month, day = post.published_on.strftime('%Y-%m-%d').split('-')
    redirect_to(permalink_path(year, month, day, post.slug))
  end

  def decorate(posts)
    PostDecorator.decorate(posts)
  end
end