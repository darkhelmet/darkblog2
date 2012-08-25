class MakeBodyHtmlRequired < ActiveRecord::Migration
  def up
    change_column :pages, :body_html, :text, :null => false
  end

  def down
    change_column :pages, :body_html, :text
  end
end
