class Admin
  include Mongoid::Document

  devise :database_authenticatable, :trackable, :lockable

  index :email, :background => true, :unique => true
end