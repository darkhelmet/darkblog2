class Post
  Yahoo = 'http://search.yahooapis.com/ContentAnalysisService/V1/termExtraction'
  Index = IndexTank::Client.new(ENV['INDEXTANK_API_URL']).indexes("#{Darkblog2.config[:search_index]}_#{Rails.env}") rescue nil

  include Mongoid::Document
  include Mongoid::Timestamps
  include Taggable

  embeds_many :pics

  before_save :slug!
  before_save :update_terms!, :unless => -> { ENV['YAHOO_APPID'].blank? }
  after_save :update_search_index!, :if => :published
  after_save :clear_cache, :if => :published
  after_save :push, :unless => :published
  after_save :schedule_announce_job, :if => :published, :unless => :announced

  field :title, type: String
  field :category, type: String
  field :body, type: String
  field :published, type: Boolean, default: false
  field :published_on, type: Time, default: -> { Chronic.parse('monday 8am') }
  field :slugs, type: Array, default: []
  field :description, type: String
  field :announced, type: Boolean, default: false
  field :terms, type: Array, default: []

  # Basic search
  index([
    [:published, Mongo::ASCENDING],
    [:published_on, Mongo::DESCENDING]
  ], background: true)

  # Search by category
  index([
    [:category, Mongo::ASCENDING],
    [:published, Mongo::ASCENDING],
    [:published_on, Mongo::DESCENDING]
  ], background: true)

  # Search by slug
  index([
    [:slugs, Mongo::ASCENDING],
    [:published, Mongo::ASCENDING],
    [:published_on, Mongo::DESCENDING]
  ], background: true)

  # Search by tags
  index([
    [:tags, Mongo::ASCENDING],
    [:published, Mongo::ASCENDING],
    [:published_on, Mongo::DESCENDING]
  ], background: true)

  # Search by terms
  index([
    [:terms, Mongo::ASCENDING],
    [:published, Mongo::ASCENDING],
    [:published_on, Mongo::DESCENDING]
  ], background: true)

  validates_presence_of :title, :category

  scope(:publish_order, -> {
    where(published: true, :published_on.lte => Time.now.utc).order_by(:published_on.desc)
  })

  def slug
    slugs.first
  end

  def slug!
    new_slug = title.parameterize
    if public?
      self.slugs.unshift(new_slug) unless slugs.include?(new_slug)
    else
      self.slugs = [new_slug]
    end
  end

  def body_html
    processed_body = body.gsub(/\{\{(\w+)(?::(\w+))?\}\}/) do |sub|
      id, version = $1, $2
      if pic = id.match(/^\d+$/) ? pics[id.to_i] : pics.detect { |p| p.image_filename.start_with?(id) }
        image = pic.image
        version.nil? ? image.url : image.url(version.to_sym)
      else
        ''
      end
    end
    RedCloth.new(processed_body).to_html
  end

  def published_on
    super.in_time_zone
  end

  def public?
    published && published_on <= Time.zone.now
  end

  def announce!
    collection.update({ _id: id }, {
      '$set' => { announced: true }
    })
  end

  def cache_key
    "post-#{id}-#{attributes.hash}"
  end

  def pusher_channel
    "post-#{id}"
  end

  def related(limit = 5)
    Post.publish_order.
      where(:terms.in => terms).
      reject { |post| post.id == id }.
      sort_by { |post| -(post.terms & terms).length }.
      take(limit)
  end

  class << self
    def find_by_permalink_params(params)
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      post = where({
        published: true,
        :published_on.gte => time.beginning_of_day.utc,
        :published_on.lte => time.end_of_day.utc,
        slugs: params[:slug]
      }).first
      # Little hack since you can't seem to do the double where clause
      post && post.published_on <= Time.now ? post : nil
    end

    def find_by_month(params)
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, 1)
      posts = where({
        :published_on.gte => time.beginning_of_month.utc,
        :published_on.lte => time.end_of_month.utc,
        published: true
      }).order_by(:published_on.desc)
      posts.reject do |post|
        # Get rid of posts that are published in the future
        post.published_on > Time.now
      end
    end

    def find_by_category(category)
      Post.publish_order.where(category: category).to_a
    end

    def categories
      collection.distinct('category')
    end

    def tags
      collection.distinct('tags')
    end

    def group_by_category
      publish_order.group_by(&:category)
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
      posts = find(Index.search(query, function: 1)['results'].map { |r| r['docid'] })
      posts.reject do |post|
        # Get rid of posts that are published in the future
        !post.published || post.published_on > Time.now
      end
    rescue
      []
    end
  end

private

  def body_for_index
    [title, clean_body, tag_string].join("\n")
  end

  def clean_body
    Sanitize.clean(body_html)
  end

  def update_search_index!
    Index.document(id).add({
      text: body_for_index,
      title: title,
      timestamp: published_on.to_i.to_s
    }) unless Index.nil?
  end

  def clear_cache
    Rails.cache.clear
  end

  def push
    Pusher[pusher_channel].trigger('post-update', attributes.merge(html: body_html))
  end

  def schedule_announce_job
    return unless Rails.env.production?
    query = {
      at: (published_on + 1.minute).to_i,
      url: "http://blog.darkhax.com/announce?auth_token=#{Admin.first.authentication_token}"
    }.map { |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join('&')
    RestClient.get("https://verbose-scheduling.appspot.com/delay?#{query}")
  end

  def update_terms!
    json = RestClient.post(Yahoo, {
      appid: ENV['YAHOO_APPID'],
      context: clean_body,
      output: 'json'
    })
    self.terms = JSON.parse(json)['ResultSet']['Result']
  end
end