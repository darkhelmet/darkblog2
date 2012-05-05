$.getScriptLite = (src) ->
  script = $('<script/>',
    src: src,
    type: 'text/javascript',
    async: 'async',
    defer: 'defer'
  ).get(0)
  $('head').get(0).appendChild(script)

$ ->
  CFInstall.check(mode: 'overlay')

  $('.content a:regex(href, png|jpe?g|gif)').fancybox({
    openEffect: 'elastic',
    openEasing: 'easeOutBack',
    closeEffect: 'elastic',
    closeEasing: 'easeInBack'
  })

  $('.content a').embedly
    urlRe: /http:\/\/(.*youtube\.com\/.*)/i,
    maxWidth: 640,
    wmode: 'opaque'

  $('.content a').embedly
    urlRe: /http:\/\/(twitter\.com\/.*\/status\/.*|twitter\.com\/.*\/statuses\/.*|mobile\.twitter\.com\/.*\/status\/.*|mobile\.twitter\.com\/.*\/statuses\/.*)/i
    success: (oembed, dict) ->
      dict.node.attr('title', oembed.description)
      dict.node.click ->
        div = $('<div class="embedly" />')
        div.html($(oembed.code))
        $.facebox(div)
        false

  $('.content a.twitter').embedly
    urlRe: /http:\/\/(twitter\.com\/.*\/status\/.*|twitter\.com\/.*\/statuses\/.*|mobile\.twitter\.com\/.*\/status\/.*|mobile\.twitter\.com\/.*\/statuses\/.*)/i
    maxWidth: 640

  $('p.footnote:first').addClass('first')

  threads = $('a[href$=#disqus_thread]')
  if threads.length > 0
    query = threads.map((a, index) ->
      "url#{index}=#{encodeURIComponent(a.href)}"
    ).join('&')
    $.getScriptLite('//disqus.com/forums/verboselogging/get_num_replies.js?' + query)

  $('.rack-gist').each ->
    $.ajax(url: $(this).attr('rack-gist-url'), dataType: 'script', cache: true)

  if document.getElementsByTagName('plusone').length > 0
    $('plusone').replaceWith('<g:plusone size="medium"></g:plusone>')
    $.getScriptLite('//apis.google.com/js/plusone.js')

  if document.getElementById('fb-root')
    $.getScriptLite('//connect.facebook.net/en_US/all.js#appId=286712658022064&xfbml=1')

  if document.getElementById('rdbWrapper')
    $.getScriptLite('//www.readability.com/embed.js')

  if document.getElementsByClassName('twitter-share-button').length > 0
    $.getScriptLite('//platform.twitter.com/widgets.js')
