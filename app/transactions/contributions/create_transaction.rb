module Contributions
  class CreateTransaction < ::BaseTransaction
    step :create_contribution
    step :find_or_create_wallet

    def create_contribution(attributes)
      @contribution = Contribution.new(attributes)
      if @contribution.save
        Success(@contribution)
      else
        Failure(error: @contribution.errors.full_messages.join(' | '), contribution: @contribution)
      end
    end

    def find_or_create_mangopay_wallet
      
    end
  end
end
