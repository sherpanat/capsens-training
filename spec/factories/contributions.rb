FactoryBot.define do
  factory :contribution do
    association :user
    association :project
    amount { 20 }
    wallet_id { "123" }

    factory :contribution_payed, class: Contribution do
      transfer_to_contribution_wallet_id { "456" }
    end
  end
end
