FactoryGirl.define do
  sequence(:title) { |n| "Post #{n}" }
  sequence(:description) { |n| "Test post #{n}" }
  sequence(:category) { |n| "category-#{n}" }

  factory :post do
    title { generate(:title) }
    description { generate(:description) }
    category { generate(:category) }
    body 'h2. Some Content'
    published true
    published_on { Time.zone.now }
  end
end
