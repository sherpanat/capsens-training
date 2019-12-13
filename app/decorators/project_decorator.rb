class ProjectDecorator < ApplicationDecorator
  delegate_all

  def percentage_of_completion
    amount_invested * 100 / target_amount
  end

  def amount_invested
    ordered_contributions_amount.sum
  end

  def higher_contribution
    ordered_contributions_amount.first
  end

  def lower_contribution
    ordered_contributions_amount.last
  end

  private

  def ordered_contributions_amount
    contributions.order(amount: :desc).pluck(:amount)
  end
end
