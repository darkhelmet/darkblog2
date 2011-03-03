require 'rack/sinatra'
require 'sinatra/bundles'

class Bundles < Rack::Sinatra
  set({
    :environment => Rails.env,
    :public => Rails.public_path,
    :logger => Rails.logger
  })

  register Sinatra::Bundles

  javascript_bundle(:all, %w(jquery rails jquery.darkblog facebox jquery.embedly jquery.boastful darkblog CFInstall))
  stylesheet_bundle(:all, %w(reset grid general facebox boastful darkblog))
end