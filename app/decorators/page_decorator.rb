class PageDecorator < ApplicationDecorator
  decorates :page

  def body_html
    RedCloth.new(body).to_html
  end
end
