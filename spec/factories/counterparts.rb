FactoryBot.define do
  factory :counterpart do
    threshold { 20 }
    description { Faker::Company.catch_phrase }
    stock { 300 }
    association :project
  end
end
