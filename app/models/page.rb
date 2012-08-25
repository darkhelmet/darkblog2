class Page < ActiveRecord::Base
  validates_presence_of :title, :slug
  validates_uniqueness_of :title, :slug

  before_validation :slug!
  before_validation :render

  class << self
    def find_by_slug(slug)
      where(slug: slug).first
    end
  end

private

  def slug!
    self.slug = title.parameterize.to_s
  end

  def render
    self.body_html = RedCloth.new(body).to_html
  end
end
