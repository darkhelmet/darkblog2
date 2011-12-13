class Page < ActiveRecord::Base
  validates_presence_of :title, :slug
  validates_uniqueness_of :title, :slug

  before_validation :slug!

  class << self
    def find_by_slug(slug)
      where(slug: slug).first
    end
  end

private

  def slug!
    self.slug = title.parameterize.to_s
  end
end
