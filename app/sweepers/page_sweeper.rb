class PageSweeper < ActionController::Caching::Sweeper
  observe :page

  def after_save(page)
    expire_action(page.slug)
  end
  alias :after_destroy :after_save
end
