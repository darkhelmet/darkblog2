class PostsController < ApplicationController
  if Rails.env.production?
    before_filter do |controller|
      if controller.request.method =~ /GET|HEAD/
        expires_in(30.minutes, :public => true)
        controller.response.cache_control[:extras] = ['must-revalidate']
        controller.response.headers['Vary'] = 'Accept-Encoding'
      end

      expires_now if controller.request.user_agent =~ /google/i
    end
  end

  def main
    # TODO: Future post
    # TODO: Set canonical url
    # TODO: Set name
    # TODO: Set description
    # TODO: Caching
    @posts = Post.publish_order.limit(6)
  end

  def permalink
    @post = Post.find_by_permalink_params(params)
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
end