class CachePostBodyHtml < ActiveRecord::Migration
  def up
    add_column :posts, :body_html, :text
  end

  def down
    remove_column :posts, :body_html
  end
end
