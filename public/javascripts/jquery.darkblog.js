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
})(jQuery);