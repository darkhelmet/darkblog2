Darkblog2::Application.routes.draw do
  devise_for :admins

  authenticate :admin do
    namespace :admin do
      resources :posts do
        member do
          get :pics
          get :uploader
        end
      end
      resources :uploads, :only => [:create,:destroy]
    end

    post '/announce' => 'application#announce', :as => :announce
  end

  root :to => 'posts#main'
  get '/opensearch.xml' => 'application#opensearch', :as => :opensearch, :format => 'xml'
  get '/search(.:format)' => 'posts#search', :as => :search
  get '/feed' => 'posts#feed', :as => :feed, :format => 'xml'
  get '/sitemap.:format' => 'posts#sitemap', :as => :sitemap, :format => 'xml', :constraints => {
    :format => /xml(\.gz)?/
  }
  get '/archive/:archive' => 'posts#archive', :as => :archive, :constraints => {
    :archive => /full|category|month/
  }
  get '/:year/:month(.:format)' => 'posts#monthly', :as => :monthly, :constraints => {
    :year => /\d{4}/,
    :month => /\d{2}/
  }
  get '/category/:category(.:format)' => 'posts#category', :as => :category
  get '/:year/:month/:day/:slug(.:format)' => 'posts#permalink', :as => :permalink, :constraints => {
    :year => /\d{4}/,
    :month => /\d{2}/,
    :day => /\d{2}/
  }
  get '/tag/:tag(.:format)' => 'posts#tag', :as => :tag

  Dir[Rails.root.join('app', 'views', 'pages', '*')].map do |path|
    path.split('/').last.split('.').first
  end.join('|').tap do |pages|
    get '/:page' => 'static#page', :as => :path, :constraints => {
      :page => Regexp.new(pages)
    }
  end

  get '/*not_found' => 'application#render_404'
end