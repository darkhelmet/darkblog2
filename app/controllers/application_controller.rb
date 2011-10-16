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

  def announce
    Post.publish_order.where(announced: false).tap do |cursor|
      unless cursor.empty?
        cursor.each(&:announce!)
        announce_new_posts
        Rails.cache.clear
      end
    end
    head(:ok)
  end

private

  def cache_key(*args)
    args.join('-')
  end

  def announce_new_posts
    RestClient.get('http://pingomatic.com/ping/?title=verbose+logging&blogurl=http%3A%2F%2Fblog.darkhax.com%2F&rssurl=http%3A%2F%2Fblog.darkhax.com%2Ffeed&chk_weblogscom=on&chk_blogs=on&chk_technorati=on&chk_feedburner=on&chk_syndic8=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_blogrolling=on&chk_blogstreet=on&chk_moreover=on&chk_weblogalot=on&chk_icerocket=on&chk_newsisfree=on&chk_topicexchange=on&chk_google=on&chk_tailrank=on&chk_bloglines=on&chk_postrank=on&chk_skygrid=on&chk_collecta=on')
    RestClient.get('http://feedburner.google.com/fb/a/pingSubmit?bloglink=http://blog.darkhax.com/')
  end
end