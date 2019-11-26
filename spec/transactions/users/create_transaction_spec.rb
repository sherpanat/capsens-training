RSpec.describe "User::CreateTransaction", type: :transaction do
  context "Create a user" do
    it "creates a user if valid attributes given" do
      expect { ::Users::CreateTransaction.call(valid_user_attributes) }
        .to change { User.count }.by(1)
    end

    it "does not create a user if invalid attributes given" do
      create(:user, email: 'nathan.patreau@capsens.fr')
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
      create(:user, email: 'nathan.patreau@capsens.fr')
      expect { ::Users::CreateTransaction.call(invalid_user_attributes) }
        .not_to change { ActionMailer::Base.deliveries.count }
    end
  end

  def valid_user_attributes
    {
      first_name: 'Nathan',
      last_name: 'Patreau',
      email: 'nathan.patreau@capsens.fr',
      birthdate: '08/09/1998',
      password: '12345678'
    }
  end

  def invalid_user_attributes
    {
      last_name: 'Patreau',
      email: 'nathan.patreau@capsens.fr',
      birthdate: '08/09/1998',
      password: '12345678'
    }
  end
end
