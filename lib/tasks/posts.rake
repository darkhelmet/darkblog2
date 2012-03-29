namespace :posts do
  desc 'Announce posts'
  task announce: :environment do
    Post.transaction do
      unless Post.unannounced.empty?
        token = AdminUser.first.authentication_token
        host = ENV.fetch('ANNOUNCE_HOST', 'localhost:3000')
        Post.unannounced.each do |post|
          RestClient.post("http://#{host}/admin/posts/#{post.id}/announce", auth_token: token)
        end
        Post.inform_google if Rails.env.production?
      end
    end
  end
end
