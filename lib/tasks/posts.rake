namespace :posts do
  desc 'Resave posts'
  task :resave => :environment do
    Post.all.each(&:save)
  end

  desc 'Announce posts'
  task :announce => :environment do
    Post.transaction do
      unless Post.unannounced.empty?
        Post.unannounced.update_all(announced: true)
        Post.inform_google
      end
    end
  end
end
