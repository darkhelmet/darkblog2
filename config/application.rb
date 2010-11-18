require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require "action_mailer/railtie" # DAMN YOU DEVISE!!!
require 'active_resource/railtie'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Darkblog2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths << Rails.root.join('lib')

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Mountain Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.generators do |g|
      g.orm :mongoid
      g.template_engine :haml
      g.test_framework :rspec, :fixture_replacement => :factory_girl
    end

    config.middleware.tap do |mw|
      require 'rack/remove_slash'
      require 'rack/sinatra'
      require 'bundles'

      mw.insert_after(Rack::Lock, Rack::RemoveSlash)
      mw.insert_before(Rack::Sendfile, Rack::ETag)
      mw.use Rack::Sinatra, Bundles.new

      mw.use Rack::Gist, :cache => ActiveSupport::Cache::DalliStore.new(:compress => true, :compress_threshold => 64.kilobytes), :jquery => false

      if Rails.env.development?
        require 'rack/showexceptions'
        mw.swap(ActionDispatch::ShowExceptions, Rack::ShowExceptions)
      end
    end
  end
end