class Contribution < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :project
  belongs_to :counterpart, optional: true

  validates :amount, presence: true

  aasm whiny_transitions: false do
    state :pending, initial: true
    state :payed
    state :cancelled

    event :pay do
      transitions from: :pending, to: :payed
    end
    event :cancel do
      transitions from: :pending, to: :cancelled
    end
  end
end
