class ApplicationController < ActionController::Base
  protect_from_forgery

  def opensearch
    response.headers['Content-Type'] = 'application/opensearchdescription+xml; charset=utf-8'
  end

  def render_404
    render(:template => 'application/not_found', :status => :not_found)
    true
  end
end
