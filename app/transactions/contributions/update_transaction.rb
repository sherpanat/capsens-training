module Contributions
  class UpdateTransaction < ::BaseTransaction
    step :create_user_contribution_wallet
    step :transfer_from_user_to_contribution_wallet

    def create_user_contribution_wallet(attributes)
      @contribution = Contribution.find(attributes['id'])
      @project = Project.find(attributes['project_id'])
      @user = User.find(attributes['user_id'])
      contribution_wallet = MangoPay::Wallet.create(
        Owners: [@user.mangopay_id],
        Description: "Contribution's wallet for #{@user.first_name} #{@user.last_name} contribution on #{@project.name} project.",
        Currency: "EUR"
      )
      @contribution.update!(wallet_id: contribution_wallet['Id'])
      p contribution_wallet
      Success(contribution: @contribution, mangopay_wallet: contribution_wallet)
    end

    def transfer_from_user_to_contribution_wallet
      transfert = MangoPay::Transfer.create(
        AuthorId: @user.mangopay_id,
        CreditedUserId: @user.mangopay_id,
        DebitedFunds: {
          Currency: "EUR",
          Amount: @contribution.amount * 100
        },
        Fees: {
          Currency: "EUR",
          Amount: 0
        },
        DebitedWalletId: @user.wallet_id,
        CreditedWalletId: @contribution.wallet_id
      )
      p transfert
      Success(contribution: @contribution, transfert_to_contribution_wallet: transfert)
    end
  end
end
