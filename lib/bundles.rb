require 'rack/sinatra'
require 'sinatra/bundles'

class Bundles < Rack::Sinatra
  set({
    :environment => Rails.env,
    :public => Rails.public_path,
    :logger => Rails.logger
  })

  register Sinatra::Bundles

  stylesheet_bundle(:all, %w(reset grid general facebox boastful darkblog))
end