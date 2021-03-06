RSpec.describe Users::CreateTransaction do
  subject { described_class.call(user_attributes) }

  context "Create a user with valid attributes" do
    let(:user_attributes) { attributes_for(:user, email: 'nathan.patreau@capsens.fr') }
    before "Create a MangoPay::NaturalUser" do
      expect(MangoPay::NaturalUser).to receive(:create).with(
        FirstName: user_attributes[:first_name],
        LastName: user_attributes[:last_name],
        Birthday: user_attributes[:birthdate].to_time.to_i,
        Nationality: "FR",
        CountryOfResidence: "FR",
        Email: user_attributes[:email]
      ).and_return("Id" => "1")
    end
    before "Create a MangoPay::Wallet" do
      expect(MangoPay::Wallet).to receive(:create).with(
        Owners: ["1"],
        Description: "#{user_attributes[:first_name]} #{user_attributes[:last_name]}'s wallet",
        Currency: "EUR"
      ).and_return("Balance"=> { "Currency" => "EUR", "Amount" => 0 }, "Owners" => [user_attributes[:mangopay_id]], "Id" => "2")
    end
    it { expect { subject }.to change { User.count }.by(1) }
    it { expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    it "sends a welcoming email to user" do
      expect_any_instance_of(UserMailer).to receive(:welcome_email)
      subject
    end
    it "sets mangopay_id" do
      expect(subject.success.mangopay_id).to eq "1"
    end
    it "sets wallet_id" do
      expect(subject.success.wallet_id).to eq "2"
    end
  end

  context "Create a user with invalid attributes" do
    let(:user_attributes) { attributes_for(:user, first_name: '') }
    before "Does not create a MangoPay::NaturalUser" do
      expect(MangoPay::NaturalUser).not_to receive(:create)
    end
    before "Does not create a MangoPay::Wallet" do
      expect(MangoPay::Wallet).not_to receive(:create)
    end
    it { expect { subject }.not_to change { User.count } }
    it { expect { subject }.not_to change { ActionMailer::Base.deliveries.count } }
  end
end
