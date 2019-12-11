class Project < ApplicationRecord
  include AASM
  aasm whiny_transitions: false

  aasm do
    state :draft, initial: true
    state :upcomming, :ongoing, :success, :failure
  end

  include ImageUploader::Attachment.new(:landscape)
  include ImageUploader::Attachment.new(:thumbnail)

  belongs_to :category, optional: true
  has_many :contributions
  has_many :contributors, through: :contributions, source: :user
  has_many :counterparts

  validates :name, :target_amount, presence: true
end
