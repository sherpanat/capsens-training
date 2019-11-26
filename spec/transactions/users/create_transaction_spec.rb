RSpec.describe Users::CreateTransaction do
  let!(:valid_user_attributes) { attributes_for(:user, email: 'nathan.patreau@capsens.fr') }
  let!(:invalid_user_attributes) { attributes_for(:user, first_name: '') }

  context "Create a user with valid attributes" do
    it { expect { described_class.call(valid_user_attributes) }.to change { User.count }.by(1) }
    it { expect { described_class.call(valid_user_attributes) }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    it "sends a welcoming email to user" do
      expect_any_instance_of(UserMailer).to receive(:welcome_email)
      described_class.call(valid_user_attributes)
    end
  end

  context "Create a user with invalid attributes" do
    it { expect { described_class.call(invalid_user_attributes) }.not_to change { User.count } }
    it { expect { described_class.call(invalid_user_attributes) }.not_to change { ActionMailer::Base.deliveries.count } }
  end
end
