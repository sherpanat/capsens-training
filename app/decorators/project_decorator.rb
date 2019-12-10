class ProjectDecorator < ApplicationDecorator
  delegate_all

  def percentage_of_completion
    amount_invested * 100 / target_amount
  end

  def amount_invested
    contributions.pluck(:amount).sum
  end
end
