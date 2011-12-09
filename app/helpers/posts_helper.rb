module PostsHelper
  def category_link(category)
    link_to(category.humanize, category_path(category))
  end

  def monthly_archive_link(str)
    year, month = Date.parse(str).strftime('%Y-%m').split('-')
    link_to(str, monthly_path(year, month))
  end
end
