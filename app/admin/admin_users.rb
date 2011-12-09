ActiveAdmin.register AdminUser do
  index do |admin|
    column :id
    column :email
    default_actions
  end

  form do |f|
    f.inputs 'Info' do
      f.inputs(:email, :password, :password_confirmation)
    end
    f.buttons
  end
end