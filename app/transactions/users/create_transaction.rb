module Users
  class CreateTransaction < ::BaseTransaction
    step :create_user
    tee :send_welcome_email

    def create_user(attributes)
      @user = User.new(attributes)
      if @user.save
        Success(@user.attributes)
      else
        Failure(error: @user.errors.full_messages.join(' | '))
      end
    end
    
    def send_welcome_email(attributes)
      UserMailer.with(user: @user).welcome_email.deliver_now
      Success(@user.attributes)
    end
  end
end
