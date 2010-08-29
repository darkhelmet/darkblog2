class Admin
  include Mongoid::Document

  devise :database_authenticatable, :trackable, :lockable, :token_authenticatable

  index :email, :background => true, :unique => true
end