require 'sinatra/base'
require 'sinatra/bundles'

class Bundles < Sinatra::Base
  set({
    :environment => Rails.env,
    :public => Rails.public_path,
    :logger => Rails.logger
  })

  register Sinatra::Bundles

  javascript_bundle(:all, %w(html5 rails application jquery.darkblog facebox darkblog))
  stylesheet_bundle(:all, %w(reset grid general facebox))
end