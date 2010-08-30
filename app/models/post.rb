class Post
  Index = IndexTank::HerokuClient.new.get_index("#{Darkblog2.config[:search_index]}-#{Rails.env}")

  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable

  before_save :slug!
  after_save :update_search_index

  field :title, :type => String
  field :category, :type => String
  field :body, :type => String
  field :published, :type => Boolean, :default => false
  field :published_on, :type => Time, :default => lambda { Time.zone.now }
  field :slug, :type => String
  field :description, :type => String
  field :announced, :type => Boolean, :default => false

  validates_presence_of :title, :category

  scope(:publish_order, lambda {
    where(:published => true, :published_on.lte => Time.zone.now).order_by(:published_on.desc)
  })

  def slug!
    self.slug = title.parameterize
  end

  def body_html
    RedCloth.new(body).to_html
  end

  def published_on
    super.in_time_zone
  end

  class << self
    def find_by_permalink_params(params)
      # FIXME: Index on publish info and slug
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      where(:published => true, :slug => params[:slug], :published_on.gte => time.beginning_of_day.utc, :published_on.lte => time.end_of_day.utc).first
    end

    def find_by_month(params)
      # FIXME: Index on basic publish info
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, 1)
      publish_order.where(:published_on.gte => time.beginning_of_month.utc, :published_on.lte => time.end_of_month.utc)
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

    def admin_index
      order_by(:published_on.desc)
    end

    def find_by_id(id)
      find(id)
    end

    def find_by_tag(tag)
      by_tag(tag).publish_order.all
    end

    def search(query)
      find(Index.search(query, :function => 0)['results'].map { |r| r['docid'] }) rescue []
    end
  end

private

  def update_search_index
    Index.add_document(id, {
      :text => Sanitize.clean(body_html),
      :title => title,
      :timestamp => published_on.to_i.to_s
    }) if published
  end
end