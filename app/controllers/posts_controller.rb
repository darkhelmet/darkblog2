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
  end

  def index
    @posts = Post.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @post = Post.first(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @post = Post.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @post = Post.first(params[:id])
  end

  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to(@post, :notice => 'Post was successfully created.') }
      else
        format.html { render(:action => 'new') }
      end
    end
  end

  def update
    @post = Post.first(params[:id])

    respond_to do |format|
      if @post.update(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
      else
        format.html { render(:action => 'edit') }
      end
    end
  end

  def destroy
    @post = Post.first(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
    end
  end
end