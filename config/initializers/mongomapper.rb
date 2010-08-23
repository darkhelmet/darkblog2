MongoMapper.connection = if Rails.env.production?
  ENV['MONGOHQ_URL'].tap do |url|
    Mongo::Connection.from_uri()
    MongoMapper.database = url.split('/').last
  end
else
  Mongo::Connection.new('localhost', 27017, :logger => Rails.logger)
  MongoMapper.database = "darkblog2-#{Rails.env}"
end