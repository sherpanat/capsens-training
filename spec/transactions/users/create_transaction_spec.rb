RSpec.describe Users::CreateTransaction do
  subject { described_class.call(user_attributes) }

  context "Create a user with valid attributes" do
    let(:user_attributes) { attributes_for(:user, email: 'nathan.patreau@capsens.fr') }
    before "Create a MangoPay::NaturalUser" do
      expect(MangoPay::NaturalUser).to receive(:create).with(
        FirstName: user_attributes[:first_name],
        LastName: user_attributes[:last_name],
        Birthday: user_attributes[:birthdate].to_time.to_i,
        Nationality: 'FR',
        CountryOfResidence: 'FR',
        Email: user_attributes[:email]
      ).and_return('Id' => '1')
    end
    it { expect { subject }.to change { User.count }.by(1) }
    it { expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    it "sends a welcoming email to user" do
      expect_any_instance_of(UserMailer).to receive(:welcome_email)
      subject
    end
    it "sets mangopay_id" do
      expect(subject.success.mangopay_id).not_to be nil
    end
  end

  context "Create a user with invalid attributes" do
    let(:user_attributes) { attributes_for(:user, first_name: '') }
    before "Does not create a MangoPay::NaturalUser" do
      expect(MangoPay::NaturalUser).not_to receive(:create)
    end
    it { expect { subject }.not_to change { User.count } }
    it { expect { subject }.not_to change { ActionMailer::Base.deliveries.count } }
  end
end
