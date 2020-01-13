module Contributions
  class CreateTransaction < ::BaseTransaction
    include Rails.application.routes.url_helpers
    step :validate_counterpart
    step :create_contribution
    step :pay_in_user_wallet

    def validate_counterpart(attributes)
      contribution = Contribution.new(attributes)
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
        CreditedWalletId: contribution.project.wallet_id,
        DebitedFunds: {
          Currency: "EUR",
          Amount: contribution.amount * 100
        },
        Fees: {
          Currency: "EUR",
          Amount: 0
        },
        CardType: "CB_VISA_MASTERCARD",
        ReturnURL: "#{url_for({action: 'index', controller: 'projects'}.merge(Rails.configuration.x.absolute_url_options))}",
        Culture: "FR"
      )
      contribution.update!(payin_id: payin_attributes['Id'])
      Success(contribution)
    end
  end
end
