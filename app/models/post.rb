class Post
  Index = IndexTank::HerokuClient.new.get_index("#{Darkblog2.config[:search_index]}-#{Rails.env}") rescue nil

  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable

  embeds_many :pics

  before_save :slug!
  after_save :update_search_index
  after_save :clear_cache
  after_save :push, :unless => :published

  field :title, :type => String
  field :category, :type => String
  field :body, :type => String
  field :published, :type => Boolean, :default => false
  field :published_on, :type => Time, :default => lambda { Time.zone.now }
  field :slug, :type => String
  field :description, :type => String
  field :announced, :type => Boolean, :default => false

  # Publish info with category
  index([
    [:published, Mongo::ASCENDING],
    [:published_on, Mongo::DESCENDING],
    [:category, Mongo::ASCENDING]
  ], :background => true)

  # Publish info with slug
  index([
    [:published, Mongo::ASCENDING],
    [:published_on, Mongo::DESCENDING],
    [:slug, Mongo::ASCENDING]
  ], :background => true)

  # Publish info with tags
  index([
    [:published, Mongo::ASCENDING],
    [:published_on, Mongo::DESCENDING],
    [:tags, Mongo::ASCENDING]
  ], :background => true)

  validates_presence_of :title, :category

  scope(:publish_order, lambda {
    where(:published => true, :published_on.lte => Time.now.utc).order_by(:published_on.desc)
  })

  def slug!
    self.slug = title.parameterize
  end

  def body_html
    processed_body = body.gsub(/\{\{(\d+)(?::(\w+))?\}\}/) do |sub|
      index, version = $1.to_i, $2
      image = pics[index].image
      version.nil? ? image.url : image.url(version.to_sym)
    end
    RedCloth.new(processed_body).to_html
  end

  def published_on
    super.in_time_zone
  end

  def announce!
    collection.update({ '_id' => id }, {
      '$set' => {
        :announced => true
      }
    })
  end

  def cache_key
    "post-#{id}-#{attributes.hash}"
  end

  def pusher_channel
    "post-#{id}"
  end

  class << self
    def find_by_permalink_params(params)
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      post = where(:published => true, :published_on.gte => time.beginning_of_day.utc, :published_on.lte => time.end_of_day.utc, :slug => params[:slug]).first
      # Little hack since you can't seem to do the double where clause
      post && post.published_on <= Time.now ? post : nil
    end

    def find_by_month(params)
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, 1)
      posts = where(:published_on.gte => time.beginning_of_month.utc, :published_on.lte => time.end_of_month.utc, :published => true).order_by(:published_on.desc)
      posts.reject do |post|
        # Get rid of posts that are published in the future
        post.published_on > Time.now
      end
    end

    def categories
      collection.distinct('category')
    end

    def tags
      collection.distinct('tags')
    end

    def group_by_category
      publish_order.group_by(&:category).sort_by { |posts| posts.first.published_on }
    end

    def group_by_month
      publish_order.group_by { |post| post.published_on.strftime('%B %Y') }
    end

    def admin_index
      order_by(:published_on.desc)
    end

    def find_by_id(id)
      find(id)
    end

    def find_by_tag(tag)
      publish_order.by_tag(tag).all
    end

    def search(query)
      posts = find(Index.search(query, :function => 0)['results'].map { |r| r['docid'] })
      posts.reject do |post|
        # Get rid of posts that are published in the future
        post.published_on > Time.now
      end
    rescue
      []
    end
  end

private

  def body_for_index
    [title, Sanitize.clean(body_html), tag_string].join("\n")
  end

  def update_search_index
    unless Index.nil?
      Index.add_document(id, {
        :text => body_for_index,
        :title => title,
        :timestamp => published_on.to_i.to_s
      }) if published
    end
  end

  def clear_cache
    Rails.cache.clear if published
  end

  def push
    Pusher[pusher_channel].trigger('post-update', attributes.merge(:html => body_html))
  end
end