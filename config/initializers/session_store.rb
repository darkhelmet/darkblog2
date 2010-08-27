# Be sure to restart your server when you modify this file.

{ :key => '_darkblog2_session' }.tap do |options|
  options[:secret] = ENV['SESSION_SECRET'] if ENV['SESSION_SECRET']
  Darkblog2::Application.config.session_store(:cookie_store, options)
end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Darkblog2::Application.config.session_store :active_record_store
