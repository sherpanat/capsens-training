RSpec.describe Users::CreateTransaction do
  subject { described_class.call(user_attributes) }

  context "Create a user with valid attributes" do
    let(:user_attributes) { attributes_for(:user, email: 'nathan.patreau@capsens.fr') }
    it { expect { subject }.to change { User.count }.by(1) }
    it { expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    it "sends a welcoming email to user" do
      expect_any_instance_of(UserMailer).to receive(:welcome_email)
      subject
    end
  end

  context "Create a user with invalid attributes" do
    let(:user_attributes) { attributes_for(:user, first_name: '') }
    it { expect { subject }.not_to change { User.count } }
    it { expect { subject }.not_to change { ActionMailer::Base.deliveries.count } }
  end
end
