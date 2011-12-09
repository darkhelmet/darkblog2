class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title, :null => false
      t.string :category, :null => false
      t.string :description, :null => false
      t.text :body, :null => false
      t.boolean :published, :null => false, :default => false
      t.boolean :announced
      t.string_array :slugs
      t.string_array :terms
      t.string_array :tags
      t.string_array :images
      t.datetime :published_on, :null => false

      t.timestamps
    end

    execute 'CREATE INDEX basic_search ON posts (published_on DESC)'
    execute 'CREATE INDEX category ON posts (category, published_on DESC)'
    execute 'CREATE INDEX slugs ON posts USING GIN (slugs)'
    execute 'CREATE INDEX tags ON posts USING GIN (tags)'
    execute 'CREATE INDEX terms ON posts USING GIN (terms)'

    # execute 'ALTER TABLE posts ADD COLUMN fts TSVECTOR'
    # execute 'CREATE INDEX search ON posts USING GIN(fts)'
    #
    # execute %Q{
    #   CREATE OR REPLACE FUNCTION update_fts_index() RETURNS trigger AS $$
    #   BEGIN
    #     NEW.fts := TO_TSVECTOR('english', COALESCE(NEW.title, '') || ' ' || COALESCE(NEW.description, '') || ' ' || COALESCE(NEW.body, ''));
    #     RETURN NEW;
    #   END;
    #   $$ LANGUAGE plpgsql
    # }
    #
    # execute %Q{
    #   CREATE TRIGGER update_fts_index
    #   AFTER INSERT OR UPDATE
    #   ON posts FOR EACH ROW
    #   EXECUTE PROCEDURE update_fts_index()
    # }
  end

  def self.down
    drop_table :posts
  end
end
