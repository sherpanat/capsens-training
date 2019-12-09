class Project < ApplicationRecord
  include ImageUploader::Attachment.new(:landscape)
  include ImageUploader::Attachment.new(:thumbnail)

  belongs_to :category, optional: true
  has_many :contributions
  has_many :users, through: :contributions
  has_many :counterparts

  validates :name, :target_amount, presence: true

  def first_level_reached?(amount)
    lower_counterpart = counterparts.find_by(level: 1)
    return false unless lower_counterpart
    amount >= lower_counterpart.threshold
  end
end
