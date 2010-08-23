if Rails.env.production?
  ENV['MONGOHQ_URL'].tap do |url|
    MongoMapper.connection = Mongo::Connection.from_uri(url)
    MongoMapper.database = url.split('/').last
  end
else
  MongoMapper.connection = Mongo::Connection.new('localhost', 27017, :logger => Rails.logger)
  MongoMapper.database = "darkblog2-#{Rails.env}"
end