Darkblog2::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: 'posts#main'
  get '/opensearch.xml' => 'application#opensearch', as: :opensearch, format: :xml
  get '/search(.:format)' => 'posts#search', as: :search
  get '/feed' => 'posts#feed', as: :feed, format: :xml
  get '/sitemap.:format' => 'posts#sitemap', as: :sitemap, format: :xml, constraints: {
    format: /xml(\.gz)?/
  }
  get '/archive/:archive' => 'posts#archive', as: :archive, constraints: {
    archive: /full|category|month/
  }
  get '/:year/:month(.:format)' => 'posts#monthly', as: :monthly, constraints: {
    year: /\d{4}/,
    month: /\d{2}/
  }
  get '/category/:category(.:format)' => 'posts#category', as: :category
  get '/:year/:month/:day/:slug(.:format)' => 'posts#permalink', as: :permalink, constraints: {
    year: /\d{4}/,
    month: /\d{2}/,
    day: /\d{2}/
  }
  get '/tag/:tag(.:format)' => 'posts#tag', as: :tag
  get '/:page' => 'pages#show', as: :page

  mount_sextant if Rails.env.development?

  get '/*not_found' => 'application#render_404'
end