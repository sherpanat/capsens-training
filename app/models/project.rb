class Project < ApplicationRecord
  include ImageUploader::Attachment.new(:landscape)
  include ImageUploader::Attachment.new(:thumbnail)

  belongs_to :category, optional: true
  has_many :contributions
  has_many :users, through: :contributions
  has_many :counterparts

  validates :name, :target_amount, presence: true

  def first_level_reached?(amount)
    amount >= counterparts.find_by(level: 1).threshold
  end
end
