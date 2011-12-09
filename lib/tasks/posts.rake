namespace :posts do
  desc 'Announce posts'
  task announce: :environment do
    Post.transaction do
      unless Post.unannounced.empty?
        Post.unannounced.update_all(announced: true)
        Post.inform_google
      end
    end
  end
end
