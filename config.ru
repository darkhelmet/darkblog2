# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'heroku/autoscale'
if Rails.env.production?
  use Heroku::Autoscale :app_name => ENV['APP_NAME'], :username => ENV['HEROKU_USERNAME'], :password => ENV['HEROKU_PASSWORD']
end
run Darkblog2::Application