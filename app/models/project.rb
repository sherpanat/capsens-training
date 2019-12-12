class Project < ApplicationRecord
  include ImageUploader::Attachment.new(:landscape)
  include ImageUploader::Attachment.new(:thumbnail)
  include AASM
  aasm whiny_transitions: false

  aasm do
    state :draft, initial: true
    state :upcoming, :ongoing, :success, :failure

    event :prepare do
      transitions from: :draft, to: :upcoming, guard: [:name?, :short_description?, :long_description?, :thumbnail, :landscape]
    end

    event :publish do
      transitions from: :upcoming, to: :ongoing, guard: :ready_for_publishing?
    end

    event :end_collect do
      transitions from: :ongoing, to: :success
      transitions from: :ongoing, to: :failure
    end
  end

  def ready_for_publishing?
    category && (counterparts.count > 0)
  end

  belongs_to :category, optional: true
  has_many :contributions
  has_many :contributors, through: :contributions, source: :user
  has_many :counterparts

  validates :name, :target_amount, presence: true
end
