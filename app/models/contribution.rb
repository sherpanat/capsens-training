class Contribution < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :project
  belongs_to :counterpart, optional: true

  validates :amount, presence: true

  aasm whiny_transitions: false do
    state :pending, initial: true
    state :payed

    event :pay do
      transitions from: :pending, to: :payed
    end
  end
end
