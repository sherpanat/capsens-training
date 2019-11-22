module Users
  class CreateTransaction < ::BaseTransaction
    step :create_user
    step :send_welcome_email

    def create_user(input)
      @user = User.create(input)
      return Failure(error: @user.errors.full_messages.join(' | ')) if @user.errors.any?
      Success(@user.attributes)
    end
    
    def send_welcome_email(input)
      UserMailer.with(user: @user).welcome_email.deliver_now

      Success(@user.attributes)
    rescue StandardError => exception
      Failure(error: exception)
    end
  end
end
