listen ENV.fetch('PORT', 3000).to_i
worker_processes 4
preload_app true
timeout 30

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
  Rails.cache.reset if Rails.cache.respond_to?(:reconnect)
end
