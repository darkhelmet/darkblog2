class PostsController < CachedController
  def main
    # TODO: Future post
    # TODO: Set canonical url
    # TODO: Set name
    # TODO: Set description
    # TODO: Caching
    vomit
    @posts = Post.publish_order.limit(6)
  end

  def permalink
    @post = Post.find_by_permalink_params(params)
    render_404 and return if @post.nil?
  end

  def category
    @posts = Post.publish_order.where(:category => params[:category])
  end

  def archive
    render(:action => "archive_#{params[:archive]}")
  end

  def monthly
    @posts = Post.find_by_month(params)
    render(:action => 'main')
  end

  def sitemap
    @posts = Post.publish_order.all
  end

  def search
    @posts = Post.search(params['q'])
  end

  def feed
    expires_now
    redirect_to(feedburner_url, :status => :moved_permanently) unless Rails.env.development? || user_agent?(/feedburner/i)
    request.headers['Content-Type'] = 'application/rss+xml; charset=utf-8'
    @posts = Post.publish_order.limit(10)
  end

  def tag
    @posts = Post.find_by_tag(params[:tag])
  end

private

  def user_agent?(ua)
    request.user_agent.match(ua)
  end

  def feedburner_url
    "http://feeds.feedburner.com/#{Darkblog2.config[:feedburner]}"
  end
end