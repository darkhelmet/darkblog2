class CreatePublishedPostsView < ActiveRecord::Migration
  def up
    sql = <<-SQL
      CREATE OR REPLACE VIEW published_posts
        (id, title, category, description,
        renderer, body, body_html,
        published, announced,
        slugs, terms, tags, images,
        published_on, created_at, updated_at)
      AS SELECT
        id, title, category, description,
        renderer, body, body_html,
        published, announced,
        slugs, terms, tags, images,
        published_on, created_at, updated_at
      FROM posts
      WHERE published = 't'
      AND published_on < CURRENT_TIMESTAMP AT TIME ZONE 'UTC'
      ORDER BY published_on DESC
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    ActiveRecord::Base.connection.execute("DROP VIEW IF EXISTS published_posts")
  end
end
