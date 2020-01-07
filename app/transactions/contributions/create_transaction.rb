module Contributions
  class CreateTransaction < ::BaseTransaction
    step :validate_counterpart
    step :create_contribution

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
  end
end
