RSpec.describe "User::CreateTransaction" do
  let!(:valid_user_attributes) { attributes_for(:user, email: 'nathan.patreau@capsens.fr') }
  let!(:invalid_user_attributes) { attributes_for(:user, first_name: '') }

  context "Create a user" do
    it "creates a user if valid attributes given" do
      expect { ::Users::CreateTransaction.call(valid_user_attributes) }
        .to change { User.count }.by(1)
    end

    it "does not create a user if invalid attributes given" do
      expect { ::Users::CreateTransaction.call(invalid_user_attributes) }
        .not_to change { User.count }
    end
  end

  context "Send welcome mail", type: :mailer do
    it "sends an email" do
      expect { ::Users::CreateTransaction.call(valid_user_attributes) }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "sends a welcoming email to user" do
      expect_any_instance_of(UserMailer).to receive(:welcome_email)
      ::Users::CreateTransaction.call(valid_user_attributes)
    end

    it "does not send an email not send" do
      expect { ::Users::CreateTransaction.call(invalid_user_attributes) }
        .not_to change { ActionMailer::Base.deliveries.count }
    end
  end
end
