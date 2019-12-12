FactoryBot.define do
  factory :contribution do
    association :user
    association :project
    amount { 20 }
  end
end
