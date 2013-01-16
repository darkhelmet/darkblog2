require 'open3'

Time.zone = 'America/Edmonton'

class ImageHasher
  def hashmap(hash)
    hash.reduce({}) do |memo, (key, value)|
      memo.merge!(key => yield(key, value))
    end
  end

  def image_hash(images)
    images.group_by do |image|
      File.basename(image, File.extname(image)).parameterize.to_s.gsub('-', '_')
    end.reduce({}) do |hash, (key, sizes)|
      urls = hashmap(sizes.index_by { |size| size.split('/')[2] }) do |size, path|
        "http://cdn.verboselogging.com#{path}"
      end
      hash.merge!(key => urls)
    end
  end
end

class Pandoc
  attr_accessor :binary, :from, :to

  def initialize(args = {})
    @from = args.fetch(:from)
    @to = args.fetch(:to)
    @binary = args.fetch(:binary) { `which pandoc`.strip }
    @arguments = [binary, args.fetch(:arguments, []), '-f', from, '-t', to].flatten.compact
  end

  def call(input, default = '')
    return default if input.blank?
    Open3.popen3(*@arguments) do |stdin, stdout, stderr|
      return process(input, stdin, stdout, stderr)
    end
  end

private

  def process(input, stdin, stdout, stderr)
    write(input, stdin)
    stdout.read.strip
  ensure
    err = stderr.read
    Rails.logger.warn(err) unless err.blank?
  end

  def write(input, io)
    io.write(input)
  ensure
    io.close
  end
end


pandoc = Pandoc.new(:from => 'textile', :to => 'markdown', :arguments => %w(--normalize --parse-raw --atx-headers --no-tex-ligatures))
ih = ImageHasher.new

Post.all.each do |post|
  h = {
    'id' => post.id,
    'author' => 'Daniel Huckstep',
    'title' => post.title,
    'category' => post.category,
    'description' => post.description,
    'published' => post.published,
    'publishedon' => post.published_on.strftime('%d %b %Y %H:%M %Z'),
    'slugs' => post.slugs,
    'tags' => post.tags
  }

  unless post.images.count.zero?
    h['images'] = ih.image_hash(post.images)
  end

  case post.renderer
  when 'markdown'
    body = post.body
  when 'textile'
    if post.images.count.zero?
      body = pandoc.call(post.body)
    else
      body = post.body_html
    end
  else
    fail 'what even happened!?'
  end

  File.open("posts/#{post.slug}.md", 'w') do |f|
    f.write(YAML.dump(h))
    f.write("---\n")
    f.write(body)
  end
end

Page.all.each do |page|
  h = {
    'id' => page.id,
    'title' => page.title,
    'author' => 'Daniel Huckstep',
    'description' => page.description,
    'published' => true,
    'publishedon' => Time.now.strftime('%d %b %Y %H:%M %Z'),
    'slugs' => [page.slug]
  }

  body = case page.id
  when 1,2
    page.body_html
  else
    pandoc.call(page.body)
  end

  File.open("pages/#{page.slug}.md", 'w') do |f|
    f.write(YAML.dump(h))
    f.write("---\n")
    f.write(body)
  end
end
