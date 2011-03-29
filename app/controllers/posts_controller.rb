class PostsController < CachedController
  respond_to :html, :json, :js

  def main
    respond_with(@posts = Post.publish_order.limit(6).to_a)
  end

  def permalink
    @post = Rails.cache.fetch(cache_key('post', 'permalink', params.hash)) { Post.find_by_permalink_params(params) }
    render_404 and return if @post.nil?
    redirect_to_post(@post) and return if @post.slug != params[:slug]
    respond_with(@post)
  end

  def category
    # FIXME: This will be a bug
    @posts = Rails.cache.fetch(cache_key('posts', 'category', params[:category].parameterize)) { Post.publish_order.where(category: params[:category]).to_a }
    render_404 and return if @posts.empty?
    respond_with(@posts)
  end

  def archive
    render(action: "archive_#{params[:archive].parameterize}")
  end

  def monthly
    @posts = Rails.cache.fetch(cache_key('posts', 'monthly', params.hash)) { Post.find_by_month(params).to_a }
    render_404 and return if @posts.empty?
    respond_with(@posts)
  end

  def sitemap
    @posts = Post.publish_order.all
  end

  def search
    respond_with(@posts = Post.search(params[:query]).to_a)
  end

  def feed
    expires_now
    unless Rails.env.development? || user_agent?(/feedburner/i) || params[:no_fb]
      redirect_to(feedburner_url, status: :moved_permanently) and return
    end
    request.headers['Content-Type'] = 'application/rss+xml; charset=utf-8'
    @posts = Post.publish_order.limit(10)
  end

  def tag
    tag = params[:tag].strip.parameterize
    @posts = Rails.cache.fetch(cache_key('posts', 'tag', tag)) { Post.find_by_tag(tag).to_a }
    respond_with(@posts)
  end

private

  def user_agent?(ua)
    request.user_agent.to_s.match(ua)
  end

  def feedburner_url
    "http://feeds.feedburner.com/#{Darkblog2.config[:feedburner]}"
  end

  def redirect_to_post(post)
    year, month, day = post.published_on.strftime('%Y-%m-%d').split('-')
    redirect_to(permalink_path(year, month, day, post.slug))
  end
end