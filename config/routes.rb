Darkblog2::Application.routes.draw do
  namespace :admin do
    resources :posts
  end

  root :to => 'posts#main'
  get '/opensearch.:format' => 'application#opensearch', :as => :opensearch, :format => 'xml'
  get '/search' => 'posts#search', :as => :search
  get '/sitemap.:format' => 'posts#sitemap', :as => :sitemap, :format => 'xml', :constraints => {
    :format => /xml(\.gz)?/
  }
  get '/archive/:archive' => 'posts#archive', :as => :archive, :constraints => {
    :archive => /full|category|month/
  }
  get '/:year/:month' => 'posts#monthly', :as => :monthly, :constraints => {
    :year => /\d{4}/,
    :month => /\d{2}/
  }
  get '/category/:category' => 'posts#category', :as => :category
  get '/:year/:month/:day/:slug' => 'posts#permalink', :as => :permalink, :constraints => {
    :year => /\d{4}/,
    :month => /\d{2}/,
    :day => /\d{2}/
  }
end