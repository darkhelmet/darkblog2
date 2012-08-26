class MakePostBodyHtmlRequired < ActiveRecord::Migration
  def up
    change_column :posts, :body_html, :text, :null => false
  end

  def down
    change_column :posts, :body_html, :text
  end
end
