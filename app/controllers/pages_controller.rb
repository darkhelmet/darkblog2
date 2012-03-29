class PagesController < CachedController
  respond_to :html

  def show
    page = Page.find_by_slug(params[:page])
    render_404 and return if page.nil?
    respond_with(@page = PageDecorator.decorate(page)) if stale?(page, :public => true)
  end
  caches_action :show, cache_path: ->(c) { c.params[:page] }
end
