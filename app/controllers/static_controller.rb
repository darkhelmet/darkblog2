class StaticController < CachedController
  def page
    render(template: ['pages', params[:page].downcase].join('/'))
  end
end