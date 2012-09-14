class PageDescription < ActiveRecord::Migration
  def up
    add_column :pages, :description, :string, :null => false, :default => ''
  end

  def down
    remove_column :pages, :description
  end
end
