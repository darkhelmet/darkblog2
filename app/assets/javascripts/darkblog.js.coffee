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
  });

  $('.content a.twitter').embedly({
    urlRe: /http:\/\/(twitter\.com\/.*\/status\/.*|twitter\.com\/.*\/statuses\/.*|mobile\.twitter\.com\/.*\/status\/.*|mobile\.twitter\.com\/.*\/statuses\/.*)/i
    maxWidth: 640
  });

$.extend({
  isMobile: ->
    navigator.userAgent.match(/iP(ad|od|hone)|BlackBerry|Android|webOS|SymbianOS/)
  showExtras: ->
    !$.isMobile() && $(window).width() > 1050 && !document.location.pathname.match(/\/admin\/posts/)
})

$(document).ready ->
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

  $('a.remote-inline').live 'click', ->
    href = this.href
    p = $(this).parent()
    $(this).replaceWith('Loading...')
    $.ajax({
      url: href,
      cache: false,
      data: {
        inline: 1
      },
      dataType: 'script',
      success: ->
        $(p).remove()
    })
    false

  $('p.footnote:first').addClass('first')
