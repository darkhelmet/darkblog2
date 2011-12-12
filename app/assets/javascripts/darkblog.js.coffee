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
  $('#boastful').boastful({ location: $('link[rel=canonical]').attr('href') })

  # Fade in images so there isn't a color "pop" document load and then on window load
  gImages = $('#where img')
  gImages.fadeIn(250)
  gImages.each ->
    # Clone image
    $this = $(this)
    $this.css({
      position: 'absolute'
    }).wrap("<div class='img_wrapper' style='display: inline-block'>").clone().addClass('img_grayscale').css({
      position: 'absolute',
      'z-index': '998',
      opacity: '0'
    }).insertBefore($this).queue ->
      el = $(this)
      el.parent().css({
        width: this.width,
        height: this.height
      })
      el.dequeue()

    this.src = $this.attr('grayscale')

  $('#where img').mouseover ->
    $(this).parent().find('img:first').stop().animate({ opacity: 1 }, 250)

  $('.img_grayscale').mouseout ->
    $(this).stop().animate({ opacity: 0 }, 250)
