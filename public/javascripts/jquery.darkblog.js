(function($) {
  $.expr[':'].regex = function(elem, index, match) {
    var matchParams = match[3].split(',');
    var validLabels = /^(data|css):/;
    var attr = {
      method: matchParams[0].match(validLabels) ? matchParams[0].split(':')[0] : 'attr',
      property: matchParams.shift().replace(validLabels,'')
    };
    var regexFlags = 'ig';
    var regex = new RegExp(matchParams.join('').replace(/^\s+|\s+$/g,''), regexFlags);
    return regex.test(jQuery(elem)[attr.method](attr.property));
  };

  $.extend(jQuery, {
    githubBadge: function(username) {
      $.getScript('http://github.com/api/v1/json/' + username + '?callback=GithubBadge');
    }
  });

  $.fn.extend({
    swfembed: function(movie, width, height) {
      this.each(function() {
        scale = 600 / width;
        w = '600px';
        h = (height * scale) + 'px';
        swfobject.embedSWF(movie, this.id, w, h, '9.0.124', 'http://s3.blog.darkhax.com/swf/expressInstall.swf',
                           null, { wmode: 'opaque', allowFullscreen: true });
      });
    },
    tooltip: function(options) {
      settings = $.extend({
        xOffset: -40,
        yOffset: 25
      }, options);

      this.each(function() {
        $(this).hover(function(e) {
          this.t = this.title;
          this.title = '';
          $('body').append($('<p>', {
            id: 'tooltip',
            text: this.t,
            css: {
              position: 'absolute'
            }
          }));
          $('#tooltip').css({
            top: (e.pageY + settings.yOffset) + 'px',
            left: (e.pageX + settings.xOffset) + 'px'
          }).fadeIn('fast');
        }, function() {
          this.title = this.t;
          $('#tooltip').remove();
        }).mousemove(function(e) {
          $('#tooltip').css({
            top: (e.pageY + settings.yOffset) + 'px',
            left: (e.pageX + settings.xOffset) + 'px'
          });
        })
      });
    }
  });
})(jQuery);