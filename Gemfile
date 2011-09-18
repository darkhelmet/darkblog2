source 'http://rubygems.org'

gem 'rails', '3.1'
gem 'haml', '~> 3.1.2' # ERB sucks
gem 'sass', '~> 3.1.2'
gem 'sass-rails', '3.1.2'
gem 'yajl-ruby', '~> 1.0.0', :require => 'yajl/json_gem' # JSON
gem 'bson_ext', '1.3.1'
gem 'mongo', '1.3.1'
gem 'mongoid', '~> 2.2.0'
gem 'hoptoad_notifier'
gem 'dalli', '~> 1.1.2', :require => 'active_support/cache/dalli_store'
gem 'RedCloth', '~> 4.2.3'
gem 'rack-gist', '~> 1.1.8', :require => 'rack/gist'
gem 'rest-client', '~> 1.6.1'
gem 'devise', '1.4.4'
gem 'sanitize', '~> 2.0.1'
gem 'carrierwave', '~> 0.5.3'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'rmagick', '~> 2.13.1'
gem 'pusher', '~> 0.8.0'
gem 'fog', '~> 0.11.0'
gem 'chronic', '~> 0.6.4'
gem 'indextank', '~> 1.0.8'
gem 'coffee-script', '~> 2.2'
gem 'jquery-rails', '~> 1.0.12'
gem 'uglifier', '~> 1.0.0'

group :development, :test do
  gem 'therubyracer', '0.9.2'
  # gem 'rspec-rails', '~> 2.6.0'
  # gem 'factory_girl_rails', '~> 1.0'
  # gem 'faker', '~> 0.9.5'
  gem 'mongrel', '1.2.0.pre2', :require => nil
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'heroku'
  gem 'awesome_print', :require => 'ap'
end

group :production do
  gem 'therubyracer-heroku', '0.8.1.pre3'
end
