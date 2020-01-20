module Contributions
  class CollectTransaction < ::BaseTransaction
    step :transfer_from_one_contribution_to_project_wallet

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
      if transfer["Status"] == "SUCCEEDED"
        contribution.collect!
        Success(contribution)
      else
        contribution.cancel!
        Failure(contribution: contribution, transfer: transfer)
      end
    end
  end
end
