require 'renderer/textile'
require 'renderer/markdown'
require 'posts_controller'

class Post < ActiveRecord::Base
  include Tags
  include PgSearch
  pg_search_scope :search_by_keywords, against: { title: 'A', description: 'B', body: 'C' }

  before_save :slug!
  after_initialize :set_default_published_on

  validates_presence_of :title, :category, :description, :body

  before_validation :render

  def slug
    slugs.first
  end

  def slugs
    Array(read_attribute(:slugs))
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
      where(terms: Array(terms).search_any(:string)).
      where('id <> ?', id).
      sort_by { |post| -(post.terms & terms).length }.
      take(limit)
  end

  def update_from_transloadit(transloadit)
    urls = transloadit.fetch('results', {}).
      values.flatten.
      map { |result| result.fetch('url', nil) }.
      compact
    paths = urls.map { |url| URI.parse(url).path }
    update_attributes(images: images | paths)
  end

  class << self
    def find_for_main_page(max = 6)
      publish_order.limit(max)
    end

    def find_for_feed(max = 10)
      publish_order.limit(max)
    end

    def find_for_sitemap
      publish_order.all
    end

    def published_in_range(start, stop)
      publish_order.
        where('posts.published_on >= ?', start).
        where('posts.published_on <= ?', stop)
    end

    def find_by_permalink_params(params)
      slug = params[:slug]
      return nil if slug.match(/[\{\}]/) # PG on Heroku chokes on this
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      slugs = Array(slug).search_any(:string)
      published_in_range(time.beginning_of_day, time.end_of_day).where(slugs: slugs).first
    end

    def publish_order
      where(published: true).
        where('posts.published_on <= ?', Time.zone.now).
        order('posts.published_on DESC')
    end

    def find_by_month(params)
      time = Time.zone.local(params[:year].to_i, params[:month].to_i, 1)
      published_in_range(time.beginning_of_month, time.end_of_month)
    end

    def find_by_category(category)
      publish_order.where(category: category)
    end

    def find_by_keywords(query)
      publish_order.search_by_keywords(query)
    end

    def categories
      connection.select_values(select('DISTINCT(posts.category)').order(:category).to_sql)
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
      where(%q(posts.body ~ '\{\{[^{]+\.[^{]+\}\}'))
    end

    def unpublished
      where(published: false)
    end

    def published
      where(published: true)
    end

    def unannounced
      publish_order.where(announced: false)
    end

    def find_by_tag(tag)
      tag = Array(tag).search_any(:string)
      publish_order.where(tags: tag)
    end

    def inform_google
      RestClient.get('http://feedburner.google.com/fb/a/pingSubmit?bloglink=http://verboselogging.com/')
    end
  end

private

  def set_default_published_on
    self.published_on ||= Chronic.parse('monday 10am')
  end

  def render
    case renderer
    when 'textile'
      self.body_html = Renderer::Textile.new(body, image_hash).to_html
    when 'markdown'
      self.body_html = Renderer::Markdown.new(body, image_hash).to_html
    else
      fail "Invalid renderer: #{renderer}"
    end
  end

  def image_hash
    image_path = PostsController.new.view_context.method(:image_path)
    images.group_by do |image|
      File.basename(image, File.extname(image)).parameterize.to_s.gsub('-', '_')
    end.reduce({}) do |hash, (key, sizes)|
      urls = hashmap(sizes.index_by { |size| size.split('/')[2] }) do |size, path|
        image_path.call(path)
      end
      hash.merge!(key => urls)
    end
  end

  def hashmap(hash)
    hash.reduce({}) do |memo, (key, value)|
      memo.merge!(key => yield(key, value))
    end
  end
end
