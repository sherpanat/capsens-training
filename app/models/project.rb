class Project < ApplicationRecord
  include ImageUploader::Attachment.new(:landscape)
  include ImageUploader::Attachment.new(:thumbnail)

  belongs_to :category, optional: true
  validates :name, :target_amount, presence: true
end
