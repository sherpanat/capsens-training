module Contributions
  class CreateTransaction < ::BaseTransaction
    step :create_contribution
    step :create_card_registration

    def create_contribution(attributes)
      @contribution = Contribution.new(attributes)
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
