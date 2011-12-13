class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body, null: false

      t.timestamps
    end

    add_index :pages, :title, unique: true
    add_index :pages, :slug, unique: true
  end
end
