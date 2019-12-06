FactoryBot.define do
  factory :counterpart_level_1, Counterpart do
    threshold { 20 }
    level { 1 }
    description { Faker::Company.catch_phrase }
    stock { 300 }
    association :project, factory: :project
  end

  factory :counterpart_level_2, Counterpart do
    threshold { 100 }
    level { 2 }
    description { Faker::Company.catch_phrase }
    stock { 50 }
    association :project, factory: :project
  end
end
