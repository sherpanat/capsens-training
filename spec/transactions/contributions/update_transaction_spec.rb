RSpec.describe Contributions::UpdateTransaction do
  subject { described_class.call(contribution_attributes) }

  context "Update a contribution with valid attributes" do
    before "creates a MangoPay::Wallet for the contribution" do
      expect(MangoPay::Wallet).to receive(:create).with(
        Owners: [user.mangopay_id],
        Description: "Contribution's wallet for #{user.first_name} #{user.last_name} contribution on #{project.name} project.",
        Currency: "EUR"
      ).and_return("Balance"=> { "Currency" => "EUR", "Amount" => 0 }, "Id" => "2")


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

    before "creates a Mangopay::Transfer from user's wallet to contribution's wallet" do
      expect(MangoPay::Transfer).to receive(:create).with(
        AuthorId: user.mangopay_id,
        CreditedUserId: user.mangopay_id,
        DebitedFunds: {
          Currency: "EUR",
          Amount: contribution.amount * 100
        },
        Fees: {
          Currency: "EUR",
          Amount: 0
        },
        DebitedWalletId: user.wallet_id,
        CreditedWalletId: contribution.wallet_id
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
    # let(:user) { create(:user) }
    # let(:project) { create(:project) }
    let(:contribution) { create(:contribution, amount: 20) }

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
