module Contributions
  class CreateTransaction < ::BaseTransaction
    step :validate_counterpart
    step :create_contribution
    step :create_card_registration

    def validate_counterpart(attributes)
      @contribution = Contribution.new(attributes)
      return Success(contribution: @contribution) unless @contribution.counterpart
      if @contribution.amount < @contribution.counterpart.threshold
        @contribution.errors.add(:counterpart, :amount_lower_than_threshold)
        Failure(error: @contribution.errors.full_messages.join(' | '), contribution: @contribution)
      else
        Success(contribution: @contribution)
      end
    end

    def create_contribution
      if @contribution.save
        Success(contribution: @contribution)
      else
        Failure(error: @contribution.errors.full_messages.join(' | '), contribution: @contribution)
      end
    end

    def create_card_registration
      card_attributes = MangoPay::CardRegistration.create(
        UserID: @contribution.user.mangopay_id,
        Currency: 'EUR'
      )
      Success(contribution: @contribution, card_attributes: card_attributes)
    end
  end
end
