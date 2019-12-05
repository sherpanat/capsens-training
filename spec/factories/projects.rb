FactoryBot.define do
  factory :project do
    name { Faker::Company.name }
    short_description { Faker::Company.catch_phrase }
    long_description { Faker::Marketing.buzzwords }
    target_amount { rand(30_000...3_000_000).round(-4) }
    association :category, factory: :category
  end
end
