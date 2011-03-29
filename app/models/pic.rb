require 'carrierwave/orm/mongoid'

class Pic
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :image, ImageUploader
  embedded_in :post, inverse_of: :pics

  validates_presence_of :image
end