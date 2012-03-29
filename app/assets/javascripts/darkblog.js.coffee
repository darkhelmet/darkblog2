window['setupEmbedly'] = ->
  $('.content a').embedly({
    urlRe: /http:\/\/(twitter\.com\/.*\/status\/.*|twitter\.com\/.*\/statuses\/.*|mobile\.twitter\.com\/.*\/status\/.*|mobile\.twitter\.com\/.*\/statuses\/.*)/i
    success: (oembed, dict) ->
      dict.node.attr('title', oembed.description)
      dict.node.click ->
        div = $("<div style='width: 600px' />")
        div.html($(oembed.code))
        $.facebox(div)
        false
  })

  $('.content a.twitter').embedly({
    urlRe: /http:\/\/(twitter\.com\/.*\/status\/.*|twitter\.com\/.*\/statuses\/.*|mobile\.twitter\.com\/.*\/status\/.*|mobile\.twitter\.com\/.*\/statuses\/.*)/i
    maxWidth: 640
  })

$ ->
  $('plusone').replaceWith('<g:plusone size="medium"></g:plusone>')
  $.getScript('https://apis.google.com/js/plusone.js')

  $('.content a:regex(href, png|jpe?g|gif)').fancybox({
    openEffect: 'elastic',
    openEasing: 'easeOutBack',
    closeEffect: 'elastic',
    closeEasing: 'easeInBack'
  })

  query = $.map($('a[href$=#disqus_thread]'), (a, index) ->
    "url#{index}=#{encodeURIComponent(a.href)}"
  ).join('&')
  $.getScript('http://disqus.com/forums/verboselogging/get_num_replies.js?' + query)

  setupEmbedly()

  $('p.footnote:first').addClass('first')
