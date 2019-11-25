module Users
  class CreateTransaction < ::BaseTransaction
    step :create_user
    tee :send_welcome_email

    def create_user(input)
      @user = User.new(input)
      if @user.save
        Success(@user.attributes)
      else
        Failure(error: @user.errors.full_messages.join(' | '))
      end
    end
    
    def send_welcome_email(input)
      UserMailer.with(user: @user).welcome_email.deliver_now
    end
  end
end
