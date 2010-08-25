module ApplicationHelper
  def yield_or_default(key, default)
    content_for(key).tap do |text|
      text << default if text.blank?
    end
  end

  def favicon_tag(path)
    tag(:link, :rel => 'icon', :type => 'image/png', :href => path)
  end

  def gravatar(email, size = 120)
    image_tag("http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}.png?s=#{size}", :alt => 'Gravatar for Daniel Huckstep')
  end
end