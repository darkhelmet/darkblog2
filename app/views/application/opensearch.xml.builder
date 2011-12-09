xml.instruct!
xml.OpenSearchDescription(xmlns: 'http://a9.com/-/spec/opensearch/1.1/', 'xmlns:moz' => 'http://www.mozilla.org/2006/browser/search/') do
  xml.ShortName(Darkblog2.config.title)
  xml.Description(Darkblog2.config.tagline)
  xml.Contact(Darkblog2.config.email)
  xml.Image(image_path('favicon.png'), height: 16, width: 16, type: 'image/png')
  xml.Url(type: 'text/html', method: 'get', template: search_url(q: '{searchTerms}'))
  xml.moz(:SearchForm, root_url)
end