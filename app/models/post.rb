class Post
  include MongoMapper::Document
  plugin Taggable

  before_save :slug!

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

  class << self
    def find_by_permalink_params(params)
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      where(:published => true, :slug => params[:slug], :published_on.gte => time.beginning_of_day, :published_on.lte => time.end_of_day).first
    end
  end
end