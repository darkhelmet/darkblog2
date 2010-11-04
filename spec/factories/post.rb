Factory.define(:post) do |p|
  p.title { Faker::Lorem.sentence }
  p.category 'testing'
  p.body { Faker::Lorem.paragraphs(5) }
  p.tags %w(foo bar baz)
end