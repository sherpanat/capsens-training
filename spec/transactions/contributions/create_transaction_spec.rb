RSpec.describe Contributions::CreateTransaction do
  subject { described_class.call(contribution_attributes) }

  context "Create a contribution with valid attributes" do
    before "creates a MangoPay::Payin::Card::Web" do
      expect(MangoPay::PayIn::Card::Web).to receive(:create).with(
        AuthorId: user.mangopay_id,
        CreditedUserId: user.mangopay_id,
        CreditedWalletId: contribution.project.wallet_id,
        DebitedFunds: {
          Currency: "EUR",
          Amount: contribution.amount * 100
        },
        Fees: {
          Currency: "EUR",
          Amount: 0
        },
        CardType: "CB_VISA_MASTERCARD",
        ReturnURL: "http://localhost:3000/projects",
        Culture: "FR"
      ).and_return("Id" => "1")
    end
    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:contribution) { create(:contribution, contribution_attributes) }

    describe "with a relevant conterpart" do
      let(:counterpart) { create(:counterpart, project: project, threshold: 20) }
      let(:contribution_attributes) { attributes_for(:contribution, amount: 20).merge(user_id: user.id, project_id: project.id, counterpart_id: counterpart.id) }
      it { expect { subject }.to change { Contribution.count }.by(1) }
      it "creates contribution with counterpart" do
        expect(subject.success.counterpart).to eq(counterpart)
      end
      it "sets payin_id" do
        expect(subject.success[:contribution].payin_id).to eq "1"
      end
    end

    describe "without any counterpart" do
      let(:contribution_attributes) { attributes_for(:contribution, amount: 20).merge(project_id: project.id, user_id: user.id) }
      it { expect { subject }.to change { Contribution.count }.by(1) }
      it "sets payin_id" do
        expect(subject.success[:contribution].payin_id).to eq "1"
      end
    end
  end

  context "Create a contribution with invalid attributes" do
    before "does not create a MangoPay::Payin::Card::Web" do
      expect(MangoPay::PayIn::Card::Web).not_to receive(:create)
    end

    describe "without any counterpart" do
      let(:contribution_attributes) { attributes_for(:contribution) }
      it { expect { subject }.not_to change { Contribution.count } }
    end
    
    describe "with counterpart out of price range" do
      let(:user) { create(:user) }
      let(:project) { create(:project) }
      let(:counterpart) { create(:counterpart, project: project, threshold: 20) }
      let(:contribution_attributes) { attributes_for(:contribution, amount: 10).merge(project_id: project.id, user_id: user.id, counterpart_id: counterpart.id) }
      it { expect { subject }.not_to change { Contribution.count } }
    end
  end
end
