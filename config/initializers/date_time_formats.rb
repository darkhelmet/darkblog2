Time::DATE_FORMATS[:post] = '%d %b %Y %I:%M %p %Z'
Time::DATE_FORMATS[:rss] = '%a, %d %b %Y %H:%M:%S %z'
Time::DATE_FORMATS[:moment] = lambda do |time|
  [time.strftime('%Y-%m-%dT%H:%M:%S'), time.formatted_offset].join('')
end