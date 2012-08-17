(($) ->
    strip = (text) -> text.replace(/^\s+|\s+$/g, '')

    $.expr[':'].regex = $.expr.createPseudo (selector) ->
        (elem) ->
            [attr, regex] = selector.split(',')
            regex = new RegExp(strip(regex), 'ig')
            regex.test($(elem)['attr'](attr))
)(jQuery)
