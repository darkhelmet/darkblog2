class CachedController < ApplicationController
  if Rails.env.production?
    before_filter do |controller|
      if controller.request.method =~ /GET|HEAD/
        expires_in(30.minutes, :public => true)
        controller.response.cache_control[:extras] = ['must-revalidate']
        controller.response.headers['Vary'] = 'Accept-Encoding'

        expires_now if controller.request.user_agent =~ /google/i
      end
    end
  end
end