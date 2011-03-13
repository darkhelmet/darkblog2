module ApplicationHelper
  def content_type_tag
    tag(:meta, 'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8')
  end

  def jquery_tag(version)
    javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js")
  end

  def font_tag(family)
    stylesheet_link_tag("http://fonts.googleapis.com/css?family=#{family}")
  end

  def yield_or_default(key, default)
    content_for?(key) ? content_for(key) : default
  end

  def favicon_tag
    favicon_link_tag('favicon.png', :type => 'image/png')
  end

  def gravatar(size = 120)
    image_tag("http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(Darkblog2.config[:email].strip.downcase)}.png?s=#{size}", :alt => "Gravatar for #{Darkblog2.config[:author]}")
  end

  def description_tag
    tag(:meta, :name => 'description', :content => yield_or_default(:description, Darkblog2.config[:tagline]))
  end

  def readability_tag
    tag(:meta, :name => 'readability-verification', :content => 'ee3QxRba5qSzvNEXBLAgbYCyCMTqMkkmJQrhvQKs')
  end

  def title_tag
    content_tag(:title, yield_or_default(:title, Darkblog2.config[:title]))
  end

  def title_text(text)
    "#{text} | #{Darkblog2.config[:title]}"
  end

  def canonical_tag
    tag(:link, :rel => 'canonical', :href => content_for(:canonical)) if content_for?(:canonical)
  end

  def opensearch_tag
    tag(:link, :rel => 'search', :type => 'application/opensearchdescription+xml', :href => opensearch_url, :title => Darkblog2.config[:title])
  end

  def sitemap_tag
    tag(:link, :rel => 'sitemap', :type => 'application/xml', :title => 'Sitemap', :href => sitemap_url)
  end

  def managing_editor
    "#{Darkblog2.config[:email]} (#{Darkblog2.config[:author]})"
  end

  def rss_tag
    auto_discovery_link_tag(:rss, feed_url, :title => "#{Darkblog2.config[:title]} RSS Feed")
  end

  def index_tag
    tag(:link, :rel => 'index', :title => Darkblog2.config[:title], :href => root_url)
  end

  def post_link(post)
    link_to(post.title, post_permalink(post), :rel => 'bookmark')
  end

  def tag_link(tag)
    link_to(tag.downcase, tag_url(tag), :rel => 'tag')
  end

  def inline?
    @inline ||= !params[:inline].to_i.zero?
  end

  def show_ads?
    !ENV['SHOW_ADS'].blank?
  end

  def render_social_links
    header_icons = {
      :twitter => {
        :grayscale => "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAADgElEQVRIDa2Wu05bQRCG1/YxxmBuweAII9HYCAqEKCmoqCLlCVKjlBFtniB9OiKlJE8QKRUtTYogISSQKbFkAhgDBtv4lvlWzNH6cEjkyCuBfcaz/z//XPZspNvtmtPT08TFxcWboaGhjyMjI2uxWCxuBrDa7Xbz4eHh1+Pj46eZmZkfuVyuEdnZ2YmvrKy8HR0d/TI+Pv4qkUhEZQ2AzphOp2MajUbn9va2fH9///7w8PC7t7i4mPE8bzuVSqXj8bip1+tGIhsIoWTKSNaiYAvxtnD99MbGxlKiijSaWq1mSPGgVqvVssEjJJlMrknmUp4YoxJFotls2hQEySKRSI+p34DwB1s+E3B5oJHrsDRiOzk5MQcHB1Z5Pp83q6urZnh4uK9MgAMHyycMRo6yu7s7s7+/b6TTrLMU32SzWTM/P98XIZv/SahOBIIifa5UKiaTyZh+O9knlBkxNExQIQSopODqjI+Mj5GutgEE/+EXhoMfdrheTKk6Ae4SlkolIzP1DJjgUD4xMWEDDQsGmyWE/aXIXEI2HB0dGdo9uEgx9d3Y2GAEnuEpvmdligo1BIFItzsaMrdBF//55ubGpi2si8lST0rZFUYaVOijh3xBGUrBcbEIWMvi11ANLg6bUOh2JE3kKlZ//OTosh0dxAJHbX3XcH193cjJ36NASUnZ06miJv9TFfs19H95+qIOrkJs1WrVNgVu6hPcG/aMr19Djh4MLoCmjRq69mKxaGdTDnybalKsdYNIU+eSgqVHp1XoDrfrCFGQkOOtUChYO0By8NuaQjo9PR06h+AQiK+QB1eFkgKIEnfuCEDebfa9iZ+riGCWl5dDD3f185uGzUFSwDk9zs/P+dlf2MOWWxoXi8D1+cWxwIE0pdNp23lEr5vCyLBxzrJH1agf+9Tmd2kYGBGjZmFhwZTLZfM3Urp5dnbW1lPBlZBPbH4NpUYd5ofmCS69CaB0bm4u+LP/TMC8NwENLjDgwO5dXl7W5bZ2JunIEaWbb91I0/Ay7ncpFhczmd8zyVA9KpH9FrCv19fXbYaaCMPS2y8ZGGCBCTYccHFD8ra2tl4vLS19mJqaeidqs8zWIBaEoqoo9f8m96LPu7u7JQgT8pcUwsnNzc28DG9KOq33qvaf7NIo3aurq+re3l7h+Pi4IjA1gGPyx3jwncIO7mIqYLLA5SoPbusP+QF4yJ9rRcEAAAAASUVORK5CYII=",
        :link => 'http://twitter.com/darkhelmetlive',
        :title => 'Follow me on Twitter'
      },
      :linkedin => {
        :grayscale => "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAD40lEQVRIDbWWzUqbURCGJ/FLYoKJPxBTEDc1iJS4qGDxCioBb6A30K502Wso3bpKF257A0Kh3kEtFMEfxKQgLgzJQmM0MVGTznNwwmcarY3twOc5Z2bO+87MOWdMoN1uy+rqauT6+vr1wMDA+1Ao9CoQCITlH4hiN6+urr7d3Nx89Dzv6/LyciOQy+VCp6en2Ugk8ml4eDiZSCSCSixK+iRKElEiOTs7a1UqlXKj0Xg7MjLyxVOypBKsDA0NpaLRKA6iUTkyI2VzP6LVEsUMKnFKK7iiXN+9er2eiMfj82SlCjFw1bu1lkI0MmHz3woZamai1aNi83B5ChJU9miz2RQdO5hkNzs76zaUSiUhIAum4/TICVhwwOURgYK1GQ0wGAzK3NycTExMuCAODg6kUCj0fa6tVks0IcdBhu5w/dlBrJfHEYTDYYnFYo6YQPoVyot4lJJzIgoT5vv7+zIzMyOXl5dyeHjosvf7mO9jRwgdFxtY8FlJ0e3s7Mj29jZTFxA3GB8uEyPZchkQjoNgOCuCR++vBnr2IJ0M/YQ4jI2NOQDmPBNAmY+OjroLhH+1WnVE6CAiYAK6uLiQwcFB5w+JEf6WIUaE6JaWltxz4Hbu7u7KxsaGWy8uLkoqlXLAVADgqakpN0JYLpdla2tL9vb2hPM3uZMhoKbAgY2UyEbm2M/Pz905sCajTCbTIcKXb3x8XBYWFlwDOT4+7mTJpSRDd+0A838AEoR9lAQdFwhBTyMgAy7X+vq68HQQqqNdS6anp+9gWkLuDHEyhdulfyAB2A4fO3PTk83JyYlsbm5KsVgU7Zcuu2Qy6bLnXNmDP2IZOkKi7SYEnA9SBDskAFgQXBDKhnB2t02kE5SfkPm9lwYAI7MsjRA954dATuQ2ojMbft2Ezs4fDHx+8ROiBxhyf4bMDbQ7e7+N/YbvSmpGDCZ+QrMbqGWBnkDw5VKx7mUDs3OGLHC2CFgjbAaIEcFuhKZjNL0R9rKxHzvyYIYQmhgwgL1A/0R4J0Mi786wVqu5FgUh788IrXWht77Kfgjvs+GLDxLIZrMvtDH/0N8zYYscA83aMiQ6rjxCK/M/FWsGD9kg03fa1IBeetqY2/oOb2jQBsRm2lgnqttzRE9j7qV/yEZ1NGg42nqpvLouChpphuj/h1AFOODyNLuSprqmZ/BBIwnTdey9PYWcKpAZlVP8phKu6TGVuPNeOp1+pvJOm/EbJXuukTztR+ltpErSVtKf2tI+a7/N5fP5IsD8245ps41PTk6mlWxY1/+EUHHaSlo5OjrKa6Ov6roGMN2Z5sic19nfr17deI+Ay4MG9/oXYIkXXIh/7vUAAAAASUVORK5CYII=",
        :link => 'http://ca.linkedin.com/in/darkhelmetlive',
        :title => 'Connect with me on Linkedin'
      },
      :skype => {
        :grayscale => "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAElklEQVRIDa2WyU4cQQyGPdBh32bYwr4MIpeEZwAEx0TKS0S5c8w1eYcolzxCpOTIAQ6cEOIACCQWhWHf951hJv6scadZcoiEpZruqrL9+7dd1RPLZrOyuLhYeHFx8TYIgk+xWOx1Xl5eIM8gmUwmrf5n0un0l5KSkl9dXV3XsYmJiRcq7/Lz87+Vl5fHS0tLYwr4DHAiCijn5+fZ09PTw7u7uw+3t7c/A118qd6HFChRXFwsV1dXopuiTG04Msb/K0pC1GdMbRMnJydD+hwP1HmZOn+jLEXTKqQYwIODA1Elm2uqpbq6WjQD8pA9+og/o0ERpKZT8A0GWIG+EEGB0rUUALa6uipnZ2dRW5tjyD4DyTGQeDxuwairezY+IRgwwApubm4sAiLBYG9vz9KqKfbILJDr62tBFx1niSOtjxwfH0tZWZk0NDRIYWGh44RPmBIk9taNTFjEmS1qCnknCBfSyhogPF2YMyjH0tKStLS0CME+FM+KMSwoKAgBcQwbV8AQYGfIOgAIwOhjz2AvlUpJZ2enzU0p9wOhkKFHydPpOwucUN9EIiFtbW1SVVUVppS9/f19WVlZsQYDnLG5uSlNTU2hnmcG7EcpZRFQZ0G9ksmk6KFly1h5MOg0Njba0MvDmg1b0kvT0dUIegSH5EEzyoz8A4ICqdQbQtrb222N9e3tbVlYWOB2sgZjDVZ0Kk8AWTs6OrJ35k4gTCnOWUSoBQF4w2DMhcAasru7KzMzM8a0srJSOjo6DGxra0suLy8tUHQ5Mu4TO2d4L6W+wSbDgTHEAdLd3S11dXVyeHhog86kxgTmQaHH+z8B2WC4gQNiyBlbW1uzhsFpRUWFDWrn3UuTzM3NWe3QQaI+qbmD27GI0vdNnPFO8ScnJw2YLiW93DjekUVFRdYcpHd8fNy6FUCCdhBnG9bQo0ERYY4BgETMk/NFs9B5tbW1UlNTY7WDMTrcMoBzB6MfBXSfPMOrzaNBmeiJCpY4HxgYsGaanp6W2dlZO3cYt2v39vf3G2Pm0UC5KPTTZF3+JEOvH0akh6YAkHT7VdXT02N7GxsbtgeraM3Q98xwFjka3uFOyLqUCcNBuYAB5cyRIs4cBx/mXALUEl1q6YIOug7IPjVzv48AUXRBmRrRoXwTx8bGZH193UA5En5EYATI/Py8BcWXwwUfzpj3R4AsuvBOqqjR8vKyAU9NTZljLoao4JQDz/Oh4MdHCAhtUuipcCMUYEIKqRmXNEcEPQ+OBmO4+Dv7pJvauz7+7FjoS1YXM9wW1CgqKMG0ubnZvhY0Es3AOsIeQREIg3VAIeDHBsBcanU7kwXhShdT2savvOPMW+4HJxgQDJ8cAKJMcAhYtGH4+vMZgwRsc9/XFFgA7ijV7/r8rM4DahR1msO1dJCSp4T0tba2GmMAAAKEQLHRGqfBUL87FKCor68vOTg4+LG+vv69pqMJps7iKYCn1ryu7GHLnOwo8Loerx/Dw8NfR0ZGlgCs0KFY9Yne3t4OLTR/SJ7nn7BePnrbnI+Ojv5W0AP1uw0gfV6sg+8PZ+Pv+dDJMwgYDA765R+AW+rHk149QgAAAABJRU5ErkJggg==",
        :link => 'skype:darkhelmetlive?call',
        :title => 'Call on me! Call me! Call on me! Call me...on Skype'
      },
      :flickr => {
        :grayscale => "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAD3UlEQVRIDbWWyU5bWRCGy+aCzWQIgxkENIoACQmEEIMYxIJNpIZNXiLbbPMGkfoZsulHyAIUkQ1IiBWwADYsEEoEYogYxWDMYHd9JerG0PSK2yUdX586deuvv4Zjx/L5vGxtbSXu7+/flZSUfCoqKhqKxWIlEoGo79uHh4fl29vbv4Ig+N7R0ZGNraysFFdUVPypii81NTV1lZWVcQWMAE4EMhcXF7mTk5MjJfTh8vLyWxCPx+t1fayurk6nUinJ5XKiUUUCqH5FfcbVZ1pBP+p+JdBNijQqS7m7u7OoomKorARf+D4/Px8CK1BlXBklYUYKEH9GQRNfgIIBVoBTwKJK438FCQYSaAcZGJFEyawQ+JGhgGUMAfII3BAjX+hesnFbmqNQngdfuA9TitIFoOPjYwptjcS+tLRU0um06KyGwQFEox0dHUk2m7WgdLxER0u0659kzAlZStm4Aid6EcjCwoI9b25uBF1dXZ0MDw/L6OiogRPc9fW1rK6uyvr6upyenhpAIpGQtrY2GRkZsacTwX+YUjYcwGRvb09mZmZkZ2dHdFwkmUzaGQ7n5uYEBjhD1tbWZGlpyd7DDsHP9va2BTM1NWWBog8JedO4gmgPDw8tdcXFxQbAk0VAy8vL3B5ydXUlGxsbFhSs3IaUs6ckm5ubYBkYUwCWVdsZEt3Z2Zl1LWlkAcLiO+xgyovUDmB0butPdAjn+GQ5IQN0hQM7iL31+FGoczuOCvVu7wE+98t5nGhx4IsO8wjdQeGzqqrK0ohTbF8SgKh/eXl56Bf//0opee7q6pLa2loz5EUXvrN6enqsS6lTZ2dnmLLndgTW3t4eXioAImENUXDZtra2yvj4uDQ3N1ttCIJVVlYm/f39Mjg4aA1CFnp7e6W7u9uaxO1gXl9fLwMDA9LU1GTvevYADOfQ2UC7r69PGhoaZH9/3waaZvCISRWBIYzC2NiYMdHfOssKXcrMsphhAsC3p9TaCQdOGUcMNC8QIWC8AANuEwLCCWI10XMGnUDQe6bw4WDYepBPrjZniQHOWS9JoR2BZDKZl8wsUA48EL4/SWmhIw6jlCcp9TR4qqIEwhdEvGT8xcjrrfFAgf0+jBoQ32CAFWgNMrq29BrqpcP+D+GKAwMsavhLFX8r0GeNIMEfHoaa7nyNkEKajnHR38ssGGDR38mJiYm309PTH1paWt7rgP+hTLWcr/tvSt0UIK/j8XN3d/fr7Ozsl8XFxW28pnQ1NDY2vpmcnGzX+69SwV5H7zE1CprTn7GL+fn5HwcHB6eqPgSQwpXqKtLF5fn7AtVNBAIGi3/XmX8Ao8zobwmnDG0AAAAASUVORK5CYII=",
        :link => 'http://www.flickr.com/photos/darkhelmetlive/',
        :title => 'My pictures on Flickr'
      },
      :rss => {
        :grayscale => "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAE8UlEQVRIDY2WyUvdVxTHz9OnRolTotE4xyiI0oUaFXXh0q24KG6LCs1/8ST/Q9tFNqGFIIK40ILisFHExcMBnOdZSZzjHLX3c5rz+PnalB647w5n+J7p3t/zPTw8SFtbW8Th4eGPbt0sImVuKMEzsvX9/b0diZ391+zz+Xadwu/X19d/fPjwYdsXCAQAu4uMjJSsrCxhdkL/GKBwHhER8Yjn3bP27tFhf3R0JCsrK3J8fFztd5ufAMnNzeVA7u7uHil5wb0GbR0+hzuF7YSEBCkuLpbh4eG3fpeOt0RmYHhF2lC0aDEaDuzleUG9cqxJ983NjQbhTP8AYDnKRAZ9/fpVSktLJS8vTz5//iwu3TrOzs5UCePImxPhYHaOLQAhAoiNjQW81M+BKcFgFBQUKCg8CCc+ffqkdVheXpaDgwM1ZnoGwmxkYOwtatZEyBw6tL0efvvx+/3y8uVLHTU1NbK6uiojIyNiUWPQQM2WV99sMj+KECGMM75HGM/Pz9eOHh8fl6mpKRW1iGwO1zdQtYwQg9o8efJEBgcHZWxsTJ4+fSqpqamSk5Mjea6mUVFRITvR0dFSVVWl3T00NCTn5+dqAwFsGYB3zVlkRUVF4MWLF+IuZgj09vZWLi8v5fT0VPb29mRmZkbm5ua0vs+fP3+UAZyiyzc2NrTWAHhBaUbr+rW1NYmsrKwMpKWlydXVlQLCxIGUlBSNmD0ppnHW19cVnCwgY0QHZmdnK+jFxYXgMPYIwkZMTIzyQyml6HiD4erqaikpKdH9ycmJzM7OyuLiokaNTH9/v3ZqXV2dYUpSUpKwb29vD10xUmgDQdYR+vPtYltbExVETZ89eya1tbXS1NSkNcNT0jY6OiodHR3qoAq7n/T0dHEl0q0BeWcYenEwgHEbpCicSGNZWZk0NDRIfHy8yi4sLEh3d/cj0fLycklOTg5FZoAEwTryzZs3gczMTH1+DBgGTYNQXFyc3jGzyj7PdSx3kfRvbW0JjWQ1pd68nZQBOwZEEJubm393qQEiTJS8KvPz8xIMBmV6elpTiIwRyhkZGSGjfAl4Du3aUIalpSV9GAwUHTpZawgI9cNjuosZcNL45csX6e3tlZ6eHvXYQKkXtUWXzpyYmDCWzoWFhRodEdqAoTUEDCXAjEk3as6dQRoFg52dnco3y9SLhwFQHgqug9GrV69U1u6hpVavBZ8PjFNDBLjMdCX3E0e6urpkZ2dH7yDfTVd3tYs812d3d1evCQ97UVGR8nAkMTFRvzQWBAxNKSnESwywrq+vVzAEaJLGxkblUyMe7fBIyBC6NJIRJaGWBsYMhVKKAkSkfBm8RC0hDPOhpvhGGKUrIZ5BL8EjY5ZWbIcuPsYYREr6vMQVgXCKsb+/H2KjY4A0mJe4LhYhYFDoacMQYDRIX1+frrkKGBkYGAjVGJnt7W196vAcwiH0qTefK0sfb68B2pmvtbX1gY8q/6xQwhMTYm/Dzi09yJjXXh582+OMrWmiyclJTWmQLqXIEABEQYMwmxMoMthb+llDxmNtZ6aHA8iD4SgY4Tx9TztzFQAwMiM2W0TsLQPetZ3ZDJCB8baSXif/pw+llpaWX1xHvX39+rW+LpyFDwxBzPDM8L+tOQOMmSu05j687lH51WXxnQJiqLm5+Wc3tTihcvYI/5/ZK/OdddDZev/x48ff4P8FljLE2L7wE2wAAAAASUVORK5CYII=",
        :link => feed_path,
        :title => 'Get new articles in your RSS reader.'
      }
    }
    [:twitter, :linkedin, :skype, :flickr, :rss].each do |icon|
      data = header_icons[icon]
      concat(link_to(image_tag("icons/#{icon}.png", :alt => "#{icon.to_s.capitalize} Icon", :grayscale => data[:grayscale], :height => 28, :width => 28), data[:link], :title => data[:title], :class => icon))
    end
  end
end