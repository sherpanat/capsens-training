RSpec.describe Contributions::CollectTransaction do
  subject { described_class.call(contribution) }

  context "Successfull mangopay transfer" do
    before "creates Mangopay::Transfer from contribution's wallet to project's wallet" do
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
        DebitedWalletId: contribution.wallet_id,
        CreditedWalletId: contribution.project.wallet_id
      ).and_return("Id" => "1", "Status" => "SUCCEEDED")
    end
    let(:contribution) { create(:contribution_payed, amount: 100) }

    it "sets transfer_to_project_wallet_id" do
      expect(subject.success.transfer_to_project_wallet_id).to eq("1")
    end
    it do
      subject
      expect(contribution).to transition_from(:payed).to(:transfered).on_event(:collect)
    end
  end

  context "Failed mangopay transfer" do
    before "creates Mangopay::Transfer from contribution's wallet to project's wallet" do
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
        DebitedWalletId: contribution.wallet_id,
        CreditedWalletId: contribution.project.wallet_id
      ).and_return("Id" => "1", "Status" => "FAILED")
    end
    let(:contribution) { create(:contribution_payed, amount: 100) }

    it "sets transfer_to_project_wallet_id" do
      expect(subject.failure[:contribution].transfer_to_project_wallet_id).to eq("1")
    end
    it do
      subject
      expect(contribution).to transition_from(:payed).to(:cancelled).on_event(:cancel)
    end
  end
end
