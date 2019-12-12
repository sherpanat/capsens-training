class Project < ApplicationRecord
  include ImageUploader::Attachment.new(:landscape)
  include ImageUploader::Attachment.new(:thumbnail)
  include Aasm::Project

  belongs_to :category, optional: true
  has_many :contributions
  has_many :contributors, through: :contributions, source: :user
  has_many :counterparts

  validates :name, :target_amount, presence: true
end
