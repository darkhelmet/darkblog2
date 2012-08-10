class PostsController < CachedController
  Archives = {
    'full' => 'full',
    'category' => 'category',
    'month' => 'month'
  }

  respond_to :html

  delegate :path, to: :request, prefix: true

  def main
    respond_with(@posts = decorate(Post.find_for_main_page))
  end
  caches_action :main, cache_path: 'main'

  def permalink
    post = Post.find_by_permalink_params(params)
    render_404 and return unless post.present?
    redirect_to_post(post) and return if post.slug != params[:slug]
    respond_with(@post = decorate(post)) if stale?(post, :public => true)
  end
  caches_action :permalink, cache_path: :request_path.to_proc

  def category
    posts = Post.find_by_category(params[:category])
    render_404 and return if posts.empty?
    respond_with(@posts = decorate(posts))
  end
  caches_action :category, cache_path: :request_path.to_proc

  def archive
    archive = Archives.fetch(params[:archive], 'full')
    render(action: "archive_#{archive}")
  end
  caches_action :archive, cache_path: :request_path.to_proc

  def monthly
    posts = Post.find_by_month(params)
    render_404 and return if posts.empty?
    respond_with(@posts = decorate(posts))
  end
  caches_action :monthly, cache_path: :request_path.to_proc

  def sitemap
    @posts = decorate(Post.find_for_sitemap)
  end

  def search
    respond_with(@posts = decorate(Post.find_by_keywords(params[:query])))
  end
  caches_action :search, cache_path: ->(c) { c.search_path(:query => params[:query]) }, expires_in: 30.minutes

  def feed
    expires_now
    unless Rails.env.development? || user_agent?(/feedburner/i) || params[:no_fb]
      redirect_to(feedburner_url, status: :moved_permanently) and return
    end
    request.headers['Content-Type'] = 'application/rss+xml; charset=utf-8'
    @posts = decorate(Post.find_for_feed)
  end

  def tag
    tag = params.fetch(:tag, '').strip.parameterize
    posts = Post.find_by_tag(tag)
    respond_with(@posts = decorate(posts))
  end
  caches_action :tag, cache_path: :request_path.to_proc

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
