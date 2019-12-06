FactoryBot.define do
  factory :contribution do
    association :user, factory: :user
    association :project, factory: :project
    amount { 20 }
  end
end
