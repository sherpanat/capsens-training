class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :counterpart, optional: true

  validates :amount, presence: true
  validate :sufficient_amount_for_counterpart, if: :counterpart

  private

  def sufficient_amount_for_counterpart
    if amount < counterpart.threshold
      errors.add(:counterpart, "Montant trop faible")
    end
  end
end
