class Admin::PostsController < ApplicationController
  respond_to :html, :json, :js

  def index
    respond_with(@posts = Post.admin_index)
  end

  def show
    @post = Post.find_by_id(params[:id])
    render(:template => 'posts/permalink')
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])

    if @post.save
      redirect_to(admin_post_url(@post), :notice => 'Post was successfully created.')
    else
      render(:action => 'new')
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      redirect_to(admin_post_url(@post), :notice => 'Post was successfully updated.')
    else
      render(:action => 'edit')
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to(admin_posts_url)
  end

  def pics
    respond_with(@post = Post.find(params[:id])) do |format|
      format.html { redirect_to(admin_post_url(@post)) }
    end
  end
end