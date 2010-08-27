String::empty: -> '' ==  this
Array::all: (f) -> -1 == this.map(f).indexOf(false)

GithubBadge: (json) ->
  if json
    badge: {
      username: json.user.login
      repos: (json.user.repositories.filter (repo) ->
        !repo.fork && !repo.description.empty()
      .sort -> Math.round(Math.random()) - 0.5).slice(0, 12)
    }
    $('#github-badge').html(Jaml.render('github-badge', badge))
    $('a.github').tooltip() unless $.browser.msie

ReaderBadge: (json) ->
  $('#reader-badge').html(Jaml.render('reader-badge', json))

$(document).ready ->
  $.getScript('http://tweetboard.com/darkhelmetlive/tb.js')
  $('.post a:regex(href, png|jpe?g|gif)').facebox()
  query: $.map($('a[href$=#disqus_thread]'), ((a, index) ->
    'url' + index + '=' + encodeURIComponent(a.href)
  )).join('&')
  $.getScript('http://disqus.com/forums/verboselogging/get_num_replies.js?' + query);

###
$(document).ready ->
  $('a.remote-inline').live('click', (->
    link: $(this)
    b: link.closest('.content').prev()
    r: link.parent()
    link.replaceWith('Loading...')
    $.get(this.href + '?t=' + (new Date()).getTime(),
          ((data) ->
            r.remove()
            b.before($(data).addClass('new-elem').css('display', 'none'))
            $('.new-elem').slideDown('slow', (-> $(this).removeClass('new-elem')))))
    false))

  $('.swfembed').each ->
    t: $(this)
    t.swfembed(t.attr('movie'), parseInt(t.attr('mwidth')), parseInt(t.attr('mheight')))

  $('#posts-container a').each ->
    re: /http:\/\/twitter\.com\/\w+\/status\/(\d+)/
    matches: re.exec($(this).attr('href'))
    if null != matches && 1 < matches.length
      id: matches[1]
      link: this
      $.get('/twitter/' + id, null, ((data) ->
        $(link).attr('title', data)
        $(link).tooltip() unless $.browser.msie
      ), 'text');

  $.githubBadge('darkhelmet')
  $.getScript("http://www.google.com/reader/public/javascript/user/13098793136980097600/state/com.google/broadcast?n=12&callback=ReaderBadge")

  true
###