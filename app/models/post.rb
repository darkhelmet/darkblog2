Chronic.time_class = Time.zone

class Post < ActiveRecord::Base
  Yahoo = 'http://search.yahooapis.com/ContentAnalysisService/V1/termExtraction'

  include Tags
  extend Searchable(:title, :description, :body)

  before_save :slug!
  before_save :update_terms!, :unless => -> { ENV['YAHOO_APPID'].blank? }
  after_initialize :set_default_published_on
  after_save :clear_cache, :if => :published

  validates_presence_of :title, :category

  def tags=(t)
    write_attribute(:tags, t.uniq)
  end

  def tag_string=(tags)
    self.tags = tags.split(',').map(&:strip).reject(&:empty?).map(&:parameterize)
  end

  def tag_string
    tags.join(', ')
  end

  def slug
    slugs.first
  end

  def slug!
    new_slug = title.parameterize.to_s
    self.slugs = if public?
      Array(new_slug) | self.slugs
    else
      Array(new_slug)
    end
  end

  def images
    Array(read_attribute(:images))
  end

  def public?
    published? && published_on <= Time.zone.now
  end

  def publish!
    update_attribute(:published, true)
  end

  def unpublish!
    update_attribute(:published, false)
  end

  def announce!
    update_attribute(:announced, true)
  end

  def cache_key
    "post-#{id}-#{attributes.hash}"
  end

  def month
    published_on.strftime('%B %Y')
  end

  def related(limit = 5)
    Post.publish_order.
      where(terms: terms.search_any(:string)).
      where('id <> ?', id).
      sort_by { |post| -(post.terms & terms).length }.
      take(limit)
  end

  def update_from_transloadit(transloadit)
    urls = transloadit['results'].values.flatten.map { |result| result['url'] }
    paths = urls.map { |url| URI.parse(url).path }
    update_attributes(images: images | paths)
  end

  class << self
    extend ActiveSupport::Memoizable

    def published_in_range(start, stop)
      publish_order.
        where('published_on >= ?', start).
        where('published_on <= ?', stop)
    end

    def find_by_permalink_params(params)
      slug = params[:slug]
      return nil if slug.include?(/[\{\}]/) # PG on Heroku chokes on this
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      slugs = Array(slug).search_any(:string)
      published_in_range(time.beginning_of_day, time.end_of_day).where(slugs: slugs).first
    end

    def publish_order
      where(published: true).
        where('published_on <= ?', Time.zone.now).
        order('published_on DESC')
    end

    def find_by_month(params)
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, 1)
      published_in_range(time.beginning_of_month, time.end_of_month)
    end

    def find_by_category(category)
      publish_order.where(category: category)
    end

    def categories
      connection.select_values(select('DISTINCT(category)').order(:category).to_sql)
    end

    def group_by_category
      publish_order.group_by(&:category)
    end

    def group_by_month
      publish_order.group_by(&:month)
    end

    def find_by_id(id)
      find(id)
    end

    def with_images
      where(%q(body ~ '\{\{[^{]+\.[^{]+\}\}'))
    end

    def unpublished
      where(published: false)
    end

    def unannounced
      publish_order.where(announced: false)
    end

    def find_by_tag(tag)
      tag = Array(tag).search_any(:string)
      publish_order.where(tags: tag)
    end

    def pull
      # This auth token doesn't matter anymore, so who cares if it's in the code?
      json = JSON.parse(RestClient.get('http://verboselogging.com/admin/posts.json?auth_token=xzakg1UypqDrzGafV6Ul'))
      transaction do
        json.reverse_each do |post|
          attrs = post.except('_id', 'pics', 'announce_job_id')
          Post.create!(attrs.merge('published_on' => Time.zone.parse(attrs.delete('published_on'))))
        end
      end
    end

    def inform_google
      RestClient.get('http://feedburner.google.com/fb/a/pingSubmit?bloglink=http://verboselogging.com/')
    end
  end

private

  def clear_cache
    Rails.cache.clear
  end

  def update_terms!
    json = RestClient.post(Yahoo, {
      appid: ENV['YAHOO_APPID'],
      context: body,
      output: 'json'
    })
    self.terms = JSON.parse(json)['ResultSet']['Result']
  end

  def set_default_published_on
    self.published_on ||= Chronic.parse('monday 10am')
  end
end
