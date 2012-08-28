class AddTruncatedHtml < ActiveRecord::Migration
  def up
    add_column :posts, :body_truncated, :text
    Post.reset_column_information
    Post.all.each(&:save!)
    change_column :posts, :body_truncated, :text, null: false
  end

  def down
    remove_column :posts, :body_truncated
  end
end
