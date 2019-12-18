class ProjectDecorator < ApplicationDecorator
  delegate_all
  decorates_association :contributions

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
