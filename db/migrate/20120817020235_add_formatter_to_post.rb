class AddFormatterToPost < ActiveRecord::Migration
  def change
    add_column :posts, :renderer, :string, :null => false, :default => 'textile'
  end
end
