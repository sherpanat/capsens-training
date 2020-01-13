RSpec.describe Contributions::UpdateTransaction do
  subject { described_class.call(contribution_attributes) }

  context "Update a contribution with valid attributes" do
    before "creates a MangoPay::Wallet for the contribution" do
      expect(MangoPay::Wallet).to receive(:create).with(
        Owners: [contribution.user.mangopay_id],
        Description: "Contribution's wallet for #{contribution.user.first_name} #{contribution.user.last_name} contribution on #{contribution.project.name} project.",
        Currency: "EUR"
      ).and_return("Balance"=> { "Currency" => "EUR", "Amount" => 0 }, "Id" => "1")
    end

    before "creates a Mangopay::Transfer from user's wallet to contribution's wallet" do
      expect(MangoPay::Transfer).to receive(:create).with(
        AuthorId: contribution.user.mangopay_id,
        CreditedUserId: contribution.user.mangopay_id,
        DebitedFunds: {
          Currency: "EUR",
          Amount: contribution.amount * 100
        },
        Fees: {
          Currency: "EUR",
          Amount: 0
        },
        DebitedWalletId: contribution.user.wallet_id,
        CreditedWalletId: "1"
      ).and_return("Balance"=> { "Currency" => "EUR", "Amount" => 0 }, "Id" => "2")
    end
      # {"Id"=>"73418415", "Tag"=>nil,
      # "CreationDate"=>1578674573,
      # "AuthorId"=>"73348151",
      # "CreditedUserId"=>"73348151",
      # "DebitedFunds"=>{"Currency"=>"EUR", "Amount"=>18},
      # "CreditedFunds"=>{"Currency"=>"EUR", "Amount"=>18},
      # "Fees"=>{"Currency"=>"EUR", "Amount"=>0},
      # "Status"=>"FAILED",
      # "ResultCode"=>"001001",
      # "ResultMessage"=>"Unsufficient wallet balance",
      # "ExecutionDate"=>nil,
      # "Type"=>"TRANSFER",
      # "Nature"=>"REGULAR",
      # "DebitedWalletId"=>"73348152",
      # "CreditedWalletId"=>"73347199"
      # }})
    let(:contribution) { create(:contribution, amount: 20) }
    let(:contribution_attributes) { contribution.attributes }
    it "sets wallet_id" do
      expect(subject.success.wallet_id).to eq "1"
    end
    it "sets transfer_id" do
      expect(subject.success.transfer_id).to eq "2"
    end
  end
end