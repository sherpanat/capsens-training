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
          Amount: 100
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
        expect(subject.success[:contribution].counterpart).to eq(counterpart)
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

# Retour de CardWebPayIn
# {"Id"=>"73348304", "Tag"=>nil, "CreationDate"=>1578565899, "AuthorId"=>"73348151", "CreditedUserId"=>"73348151", "DebitedFunds"=>{"Currency"=>"EUR", "Amount"=>13}, "CreditedFunds"=>{"Currency"=>"EUR", "Amount"=>12}, "Fees"=>{"Currency"=>"EUR", "Amount"=>1}, "Status"=>"CREATED", "ResultCode"=>nil, "ResultMessage"=>nil, "ExecutionDate"=>nil, "Type"=>"PAYIN", "Nature"=>"REGULAR", "CreditedWalletId"=>"73347199", "DebitedWalletId"=>nil, "PaymentType"=>"CARD", "ExecutionType"=>"WEB", "RedirectURL"=>"https://homologation-secure-p.payline.com/webpayment/step2.do?reqCode=prepareStep2&token=1dfA8ePE1GI5cR9G43201578565899693", "ReturnURL"=>"http://localhost:3000/projects?transactionId=73348304", "TemplateURL"=>"https://api.sandbox.mangopay.com/Content/PaylineTemplate?rp=7a56e8af8c5a4ce8a5c6e025ec143f8c&transactionId=73348304", "CardType"=>"CB_VISA_MASTERCARD", "Culture"=>"FR", "SecureMode"=>"DEFAULT", "StatementDescriptor"=>nil}
