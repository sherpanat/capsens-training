class Project < ApplicationRecord
  include ImageUploader::Attachment.new(:landscape)
  include ImageUploader::Attachment.new(:thumbnail)
  include AASM

  scope :visibles, -> do
    where(aasm_state: ["ongoing", "upcoming", "success"])
  end

  belongs_to :category, optional: true
  has_many :contributions
  has_many :contributors, through: :contributions, source: :user
  has_many :counterparts, dependent: :destroy

  validates :name, :target_amount, presence: true
  validates :target_amount, numericality: { greater_than: 0, only_integer: true }

  def percentage_of_completion
    amount_invested * 100 / target_amount
  end

  def amount_invested
    contributions.pluck(:amount).sum
  end

  def ready_for_preparation?
    name? && short_description? && long_description? && thumbnail && landscape
  end

  def ready_for_publishing?
    category && (counterparts.count > 0)
  end

  def project_completed?
    percentage_of_completion >= 100
  end

  aasm whiny_transitions: false do
    state :draft, initial: true
    state :upcoming, :ongoing, :success, :failure

    event :prepare do
      transitions from: :draft, to: :upcoming, guard: :ready_for_preparation?
    end

    event :publish do
      transitions from: :upcoming, to: :ongoing, guard: :ready_for_publishing?
    end

    event :end_collect do
      transitions from: :ongoing, to: :success, guard: :project_completed?
      transitions from: :ongoing, to: :failure
    end
  end
end
