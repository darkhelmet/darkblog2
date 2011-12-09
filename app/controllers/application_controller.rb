class ApplicationController < ActionController::Base
  protect_from_forgery

  def opensearch
    response.headers['Content-Type'] = 'application/opensearchdescription+xml; charset=utf-8'
  end

  def render_404
    respond_to do |format|
      format.html { render(template: 'application/not_found', status: :not_found) }
      format.any(:json, :js) { render(nothing: true, status: :not_found) }
    end
    true
  end

private

  def cache_key(*args)
    args.join(':')
  end
end