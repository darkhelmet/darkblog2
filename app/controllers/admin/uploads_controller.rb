class Admin::UploadsController < ApplicationController
  def create
    post.pics.create(image: params[:file]) if params[:file]
  ensure
    head(:ok)
  end

  def destroy
    post.pics.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to(edit_admin_post_path(@post)) }
      format.js do
        render(js: %Q{$('.pics li[pic_id="#{params[:id]}"]').fadeOut(function() { $(this).remove(); });})
      end
    end
  end

private

  def post
    @post ||= Post.find(post_id)
  end

  def post_id
    @post_id ||= params[:post_id]
  end
end