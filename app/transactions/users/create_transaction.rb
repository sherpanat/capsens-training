module Users
  class CreateTransaction < ::BaseTransaction
    step :create_user
    step :create_mangopay_user
    step :create_mangopay_wallet
    tee :send_welcome_email

    def create_user(attributes)
      @user = User.new(attributes)
      if @user.save
        Success(user: @user)
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
      @user.update!(mangopay_id: mangopay_user['Id'])
      Success(user: @user, mangopay_user: mangopay_user)
    end

    def create_mangopay_wallet
      mangopay_wallet = MangoPay::Wallet.create(
        Owners: [@user.mangopay_id],
        Description: "#{@user.first_name} #{@user.last_name}'s wallet",
        Currency: "EUR"
      )
      @user.update!(wallet_id: mangopay_wallet['Id'])
      Success(user: @user, mangopay_wallet: mangopay_wallet)
    end

    def send_welcome_email(attributes)
      UserMailer.with(user: @user).welcome_email.deliver_now
    end
  end
end
