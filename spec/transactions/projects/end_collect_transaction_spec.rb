RSpec.describe Projects::EndCollectTransaction do
  subject { described_class.call(project) }

  context "End Collect when collect completed" do
    let(:project) { create(:project_with_counterparts, target_amount: 100) }
    describe "with several contributions" do
      before "creates as many Mangopay::Transfer from contribution's wallet to project's wallet" do
        expect(MangoPay::Transfer).to receive(:create).twice.and_return("Id" => "1")
      end

      it "treats several contributions" do
        project
        project.prepare!
        project.publish!
        create(:contribution_payed, amount: 20, project: project).pay!
        create(:contribution_payed, amount: 90, project: project).pay!
        project.end_collect!
        result = subject.success
        expect(result).to be_an_instance_of(Array)
        expect(result.size).to eq(2)
      end
    end

    describe "with one contribution" do
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
        ).and_return("Id" => "1")
      end
      let(:contribution) { create(:contribution_payed, amount: 100, project: project) }

      it "sets transfer_to_project_wallet_id" do
        project.prepare!
        project.publish!
        project.end_collect!
        contribution.pay!
        result = subject.success
        expect(result).to be_an_instance_of(Array)
        expect(result.first.transfer_to_project_wallet_id).to eq("1")
      end
    end
  end
end
