module Users
  class CreateTransaction < ::BaseTransaction
    step :create_user
    tee :create_mangopay_user
    tee :send_welcome_email

    def create_user(attributes)
      @user = User.new(attributes)
      if @user.save
        Success(@user)
      else
        Failure(error: @user.errors.full_messages.join(' | '), user: @user)
      end
    end

    def create_mangopay_user
      mangopay_user = MangoPay::NaturalUser.create(
        FirstName: @user.first_name,
        LastName: @user.last_name,
        Birthday: @user.birthdate.to_time.to_i,
        Nationality: 'FR',
        CountryOfResidence: 'FR',
        Email: @user.email
      )
      @user.update(mangopay_id: mangopay_user['Id'])
    end

    def send_welcome_email(attributes)
      UserMailer.with(user: @user).welcome_email.deliver_now
    end
  end
end
