MongoMapper.connection = Rails.env.production? ? Mongo::Connection.from_uri(ENV['MONGOHQ_URL']) : Mongo::Connection.new('localhost', 27017)
MongoMapper.database = "darkblog2-#{Rails.env}"