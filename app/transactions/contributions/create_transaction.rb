module Contributions
  class CreateTransaction < ::BaseTransaction
    step :validate_counterpart
    step :create_contribution
    step :pay_in_user_wallet

    def validate_counterpart(attributes)
      @return_url = attributes[:return_url]
      contribution = Contribution.new(attributes.except(:return_url))
      return Success(contribution) unless contribution.counterpart
      if contribution.amount < contribution.counterpart.threshold
        contribution.errors.add(:counterpart, :amount_lower_than_threshold)
        Failure(error: contribution.errors.full_messages.join(' | '), contribution: contribution)
      else
        Success(contribution)
      end
    end

    def create_contribution(contribution)
      if contribution.save
        Success(contribution)
      else
        Failure(error: contribution.errors.full_messages.join(' | '), contribution: contribution)
      end
    end

    def pay_in_user_wallet(contribution)
      payin_attributes = MangoPay::PayIn::Card::Web.create(
        AuthorId: contribution.user.mangopay_id,
        CreditedUserId: contribution.user.mangopay_id,
        CreditedWalletId: contribution.user.wallet_id,
        DebitedFunds: {
          Currency: "EUR",
          Amount: contribution.amount * 100
        },
        Fees: {
          Currency: "EUR",
          Amount: 0
        },
        CardType: "CB_VISA_MASTERCARD",
        ReturnURL: "#{@return_url}",
        Culture: "FR"
      )
      contribution.update!(payin_id: payin_attributes['Id'])
      Success(contribution: contribution, redirect_url: payin_attributes["RedirectURL"])
    end
  end
end
