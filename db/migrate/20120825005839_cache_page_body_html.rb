class CachePageBodyHtml < ActiveRecord::Migration
  def up
    add_column :pages, :body_html, :text
  end

  def down
    remove_column :pages, :body_html
  end
end
