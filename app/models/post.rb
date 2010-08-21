class Post
  include MongoMapper::Document
  plugin Taggable

  before_create :slug!

  key :title, String, :required => true
  key :category, String, :required => true
  key :body, String
  key :published, Boolean, :default => false
  key :published_on, Time, :default => lambda { Time.zone.now }
  key :slug, String
  key :description, String

  scope(:publish_order, sort(:published_on.desc).where(:published => true))

  def slug!
    self.slug = title.parameterize
  end

  def body_html
    RedCloth.new(body).to_html
  end
end