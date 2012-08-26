class PrerenderPosts < ActiveRecord::Migration
  def up
    Post.reset_column_information
    Post.all.each(&:save!)
  end

  def down
  end
end
