class PostsController < CachedController
  respond_to :html, :json, :js

  def main
    # TODO: Future post
    # TODO: Caching
    @posts = Post.publish_order.limit(6)
  end

  def permalink
    @post = Post.find_by_permalink_params(params)
    render_404 and return if @post.nil?
    respond_with(@post)
  end

  def category
    @posts = Post.publish_order.where(:category => params[:category])
    render_404 and return if @posts.empty?
    respond_with(@posts)
  end

  def archive
    render(:action => "archive_#{params[:archive]}")
  end

  def monthly
    @posts = Post.find_by_month(params)
    render_404 and return if @posts.empty?
    respond_with(@posts)
  end

  def sitemap
    @posts = Post.publish_order.all
  end

  def search
    respond_with(@posts = Post.search(params[:query]))
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
    request.user_agent.to_s.match(ua)
  end

  def feedburner_url
    "http://feeds.feedburner.com/#{Darkblog2.config[:feedburner]}"
  end
end