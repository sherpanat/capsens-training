FactoryBot.define do
  factory :contribution do
    association :user
    association :project
    amount { 20 }
    wallet_id { "123" }
  end

  factory :contribution_payed, class: Contribution do
    association :user
    association :project, factory: :project_with_counterparts
    amount { 20 }
    wallet_id { "123" }
    transfer_to_contribution_wallet_id { "456" }
  end
end
