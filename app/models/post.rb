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
  key :announced, Boolean, :default => false

  timestamps!

  scope(:publish_order, lambda {
    where(:published => true, :published_on.lte => Time.zone.now).sort(:published_on.desc)
  })

  def slug!
    self.slug = title.parameterize
  end

  def body_html
    RedCloth.new(body).to_html
  end

  class << self
    def find_by_permalink_params(params)
      # FIXME: Index on publish info and slug
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      where(:published => true, :slug => params[:slug], :published_on.gte => time.beginning_of_day, :published_on.lte => time.end_of_day).first
    end

    def find_by_month(params)
      # FIXME: Index on basic publish info
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, 1)
      publish_order.where(:published_on.gte => time.beginning_of_month, :published_on.lte => time.end_of_month)
    end

    def categories
      # FIXME: Index on basic publish info and category
      collection.distinct('category', {
        :published => true,
        :published_on => {
          '$lte' => Time.zone.now.utc
        }
      }).sort
    end

    def group_by_category
      # FIXME: Index on basic publish info
      publish_order.group_by(&:category).sort_by(&:first)
    end

    def group_by_month
      # FIXME: Index on basic publish info
      publish_order.group_by { |post| post.published_on.strftime('%B %Y') }
    end
  end
end