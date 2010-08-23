MongoMapper.connection = if Rails.env.production?
  Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
else
  Mongo::Connection.new('localhost', 27017, :logger => Rails.logger)
  MongoMapper.database = "darkblog2-#{Rails.env}"
end