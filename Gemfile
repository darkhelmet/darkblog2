source 'http://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.6'
gem 'haml', '~> 3.1.3' # ERB sucks
gem 'sass', '~> 3.1.10'
gem 'sass-rails', '~> 3.2.3'
gem 'json', '~> 1.7.0'
gem 'airbrake', '~> 3.1.0'
gem 'kgio', '~> 2.7.4'
gem 'dalli', '~> 2.0.1'
gem 'RedCloth', '~> 4.2.3'
gem 'rack-gist', '~> 1.2.1', :require => 'rack/gist'
gem 'rest-client', '~> 1.6.1'
gem 'sanitize', '~> 2.0.1'
gem 'chronic', '~> 0.6.4'
gem 'texticle', '~> 2.0.2', :require => ['texticle/rails', 'texticle/searchable']
gem 'coffee-script', '~> 2.2'
gem 'coffee-rails', '~> 3.2.1'
gem 'jquery-rails', '~> 2.0'
gem 'uglifier', '~> 1.1'
gem 'pg', '~> 0.11'
gem 'ar_pg_array', '~> 0.9.0'
gem 'activeadmin', '0.4.0'
gem 'draper', '~> 0.11'
gem 'fog', '~> 1.3.0' # Talk to S3 for backups
gem 'rack-contrib', '~> 1.1.0'
gem 'newrelic_rpm'
gem 'sextant'

group :production do
  gem 'unicorn', '~> 4.3.0'
end

group :development, :test do
  gem 'debugger'
  gem 'thin'
  gem 'passenger'
  gem 'heroku'
  gem 'awesome_print', :require => 'ap'
  gem 'foreman'
  gem 'rack-mini-profiler'
end
