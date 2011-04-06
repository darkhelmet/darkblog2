namespace :posts do
  desc 'Resave posts'
  task :resave => :environment do
    Post.all.each(&:save)
  end
end
