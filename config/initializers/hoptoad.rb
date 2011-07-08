# http://help.hoptoadapp.com/discussions/problems/778-nomethoderror-params_filters#comment_2409830
module HoptoadNotifier
  class Notice
    private
    def also_use_rack_params_filters
      if args[:rack_env]
        params_filters = self.params_filters + (rack_request.env["action_dispatch.parameter_filter"] || [])
      end
    end
  end
end

# Move the Hoptoad middleware WAY up the stack.
Rails.application.config.middleware.tap do |mw|
  mw.delete(HoptoadNotifier::Rack)
  mw.insert_before(Rack::Gist, HoptoadNotifier::Rack)
end

HoptoadNotifier.configure do |config|
  config.api_key = ENV['HOPTOAD_API_KEY']
end