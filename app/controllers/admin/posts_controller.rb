class Admin::PostsController < ApplicationController
  respond_to :html, :json, :js

  def index
    respond_with(@posts = Post.admin_index)
  end

  def show
    respond_with(post) do |format|
      format.html { render(:template => 'posts/permalink') }
    end
  end

  def new
    @post = Post.new
  end

  def edit
    post
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
    post.update_attributes(params[:post])
    respond_with(post) do |format|
      format.html do
        if post.valid?
          redirect_to(admin_post_url(post), :notice => 'Post was successfully updated.')
        else
          render(:action => 'edit')
        end
      end
      format.js do
        if post.valid?
          render(:js => %Q{
            $('#title').pulse({
              opacity: [0,1]
            }, {
              times: 3,
              easing: 'linear',
              duration: 'slow'
            });
          })
        else
          render(:js => %Q{alert(#{@post.errors.full_messages.join('. ').to_json})})
        end
      end
    end
  end

  def destroy
    post.destroy
    respond_with(post) do |format|
      format.html { redirect_to(admin_posts_url) }
      format.js do
        render(:js => %Q{
          $('tr[post_id="#{post.id}"]').fadeOut(function() {
            $(this).remove();
          })
        })
      end
    end
  end

  def pics
    respond_with(post) do |format|
      format.html { redirect_to(admin_post_url(@post)) }
    end
  end

  def uploader
    respond_with(post) do |format|
      format.html { render(:action => 'uploader', :layout => false) }
    end
  end

private

  def post
    @post ||= Post.find(params[:id])
  end
end