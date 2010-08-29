class PostsController < CachedController
  respond_to :html, :json

  def main
    # TODO: Future post
    # TODO: Caching
    respond_with(@posts = Post.publish_order.limit(6))
  end

  def permalink
    respond_with(@post = Post.find_by_permalink_params(params))
    render_404 and return if @post.nil?
  end

  def category
    respond_with(@posts = Post.publish_order.where(:category => params[:category]))
  end

  def archive
    render(:action => "archive_#{params[:archive]}")
  end

  def monthly
    respond_with(@posts = Post.find_by_month(params))
    render(:action => 'main')
  end

  def sitemap
    @posts = Post.publish_order.all
  end

  def search
    respond_with(@posts = Post.search(params['q']))
  end

  def feed
    expires_now
    redirect_to(feedburner_url, :status => :moved_permanently) unless Rails.env.development? || user_agent?(/feedburner/i)
    request.headers['Content-Type'] = 'application/rss+xml; charset=utf-8'
    @posts = Post.publish_order.limit(10)
  end

  def tag
    respond_with(@posts = Post.find_by_tag(params[:tag]))
  end

private

  def user_agent?(ua)
    request.user_agent.match(ua)
  end

  def feedburner_url
    "http://feeds.feedburner.com/#{Darkblog2.config[:feedburner]}"
  end
end