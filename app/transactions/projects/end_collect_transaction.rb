module Projects
  class EndCollectTransaction < ::BaseTransaction
    step :transfer_all_contributions_to_project_wallet

    def transfer_all_contributions_to_project_wallet(project)
      contributions = project.contributions.payed.where.not(transfer_to_contribution_wallet_id: nil).map do |contribution|
        transfer_from_one_contribution_to_project_wallet(contribution)
      end
      Success(contributions)
    end

    def transfer_from_one_contribution_to_project_wallet(contribution)
      transfer = MangoPay::Transfer.create(
        AuthorId: contribution.user.mangopay_id,
        CreditedUserId: contribution.user.mangopay_id,
        DebitedFunds: {
          Currency: "EUR",
          Amount: contribution.amount * 100
        },
        Fees: {
          Currency: "EUR",
          Amount: 0
        },
        DebitedWalletId: contribution.wallet_id,
        CreditedWalletId: contribution.project.wallet_id
      )
      contribution.update!(transfer_to_project_wallet_id: transfer['Id'])
      contribution
    end
  end
end
