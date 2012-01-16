class YahooTermUpdaterObserver < ActiveModel::Observer
  observe :post

  def before_save(post)
    body = post.body
    unless body.blank?
      json = RestClient.post(Yahoo, options(body))
      post.terms = JSON.parse(json)['ResultSet']['Result']
    end
  end

private

  def options(body)
    {
      appid: ENV['YAHOO_APPID'],
      context: body,
      output: 'json'
    }
  end
end
