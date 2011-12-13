task backup: :environment do
  Fog::Storage.new({
    provider: 'AWS',
    aws_access_key_id: ENV['ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['SECRET_ACCESS_KEY']
  }).tap do |storage|
    storage.directories.get(ENV['BACKUP_BUCKET']).tap do |directory|
      directory.files.create({
        key: "backups/#{Time.now.strftime('%Y-%m-%d-%H-%M')}.json",
        body: {
          posts: Post.all,
          pages: Page.all
        }.to_json,
        content_type: 'application/json',
        acl: 'private'
      })
    end
  end
end