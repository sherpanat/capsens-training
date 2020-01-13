FactoryBot.define do
  factory :contribution do
    association :user
    association :project
    amount { 20 }
    wallet_id { "123" }
  end
end
