Darkblog2::Application.routes.draw do
  namespace :admin do
    resources :posts
  end

  root :to => 'posts#main'
  match '/archive/:archive' => 'posts#archive', :as => :archive, :constraints => {
    :archive => /full|category|month/
  }
  match '/:year/:month' => 'posts#monthly', :as => :monthly, :constraints => {
    :year => /\d{4}/,
    :month => /\d{2}/
  }
  match '/category/:category' => 'posts#category', :as => :category
  match '/:year/:month/:day/:slug' => 'posts#permalink', :as => :permalink, :constraints => {
    :year => /\d{4}/,
    :month => /\d{2}/,
    :day => /\d{2}/
  }
end