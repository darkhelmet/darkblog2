class Admin::UploadsController < ApplicationController
  def create
    path = Rails.root.join('tmp', filename)
    File.open(path, 'w') { |f| f.write(request.body.read) }
    post.pics.create(:image => File.open(path))
    head(:ok)
  ensure
    File.delete(path) rescue nil
  end

  def destroy
    post.pics.find(params[:id]).destroy
    redirect_to(edit_admin_post_path(@post))
  end

private

  def post
    @post ||= Post.find(post_id)
  end

  def post_id
    @post_id ||= request.referrer.split('/').tap { |parts| parts.pop }.last
  end

  def filename
    request.headers['X-File-Name']
  end

  def filesize
    request.headers['X-File-Size'].to_i
  end
end