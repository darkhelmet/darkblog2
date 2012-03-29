class FixAnnouncedField < ActiveRecord::Migration
  def up
    change_column :posts, :announced, :boolean, null: false, default: false
  end

  def down
    change_column :posts, :announced, :boolean
  end
end
