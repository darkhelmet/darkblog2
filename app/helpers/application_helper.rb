module ApplicationHelper
  def yield_or_default(key, default)
    returning(content_for(key)) do |text|
      text << default if text.blank?
    end
  end
end
