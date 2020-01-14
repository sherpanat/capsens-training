module Users
  class CreateTransaction < ::BaseTransaction
    step :create_user
    tee :send_welcome_email

    def create_user(attributes)
      user = User.new(attributes)
      if user.save
        Success(user)
      else
        Failure(error: user.errors.full_messages.join(' | '), user: user)
      end
    end

    def send_welcome_email(user)
      UserMailer.with(user: user).welcome_email.deliver_now
    end
  end
end
