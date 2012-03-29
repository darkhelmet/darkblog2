class AddAuthenticationTokenToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :authentication_token, :string
  end
end
