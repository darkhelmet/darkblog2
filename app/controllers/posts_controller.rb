class PostsController < ApplicationController
  def main
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

  def index
    @posts = Post.all
  end

  def show
    @post = Post.first(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.first(params[:id])
  end

  def create
    @post = Post.new(params[:post])

    if @post.save
      redirect_to(@post, :notice => 'Post was successfully created.')
    else
      render(:action => 'new')
    end
  end

  def update
    @post = Post.first(params[:id])

    if @post.update(params[:post])
      redirect_to(@post, :notice => 'Post was successfully updated.')
    else
      render(:action => 'edit')
    end
  end

  def destroy
    @post = Post.first(params[:id])
    @post.destroy

    redirect_to(posts_url)
  end
end