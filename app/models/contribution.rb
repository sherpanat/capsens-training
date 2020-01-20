class Contribution < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :project
  belongs_to :counterpart, optional: true

  validates :amount, presence: true

  aasm whiny_transitions: false do
    state :pending, initial: true
    state :payed, :cancelled, :transfered

    event :pay do
      transitions from: :pending, to: :payed
    end
    event :collect do
      transitions from: :payed, to: :transfered
    end
    event :cancel do
      transitions from: [:pending, :payed], to: :cancelled
    end
  end
end
