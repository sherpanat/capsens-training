module Contributions
  class CreateTransaction < ::BaseTransaction
    step :create_contribution

    def create_contribution(attributes)
      @contribution = Contribution.new(attributes)
      if @contribution.save
        Success(@contribution)
      else
        Failure(error: @contribution.errors.full_messages.join(' | '), contribution: @contribution)
      end
    end
  end
end
