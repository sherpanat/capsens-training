class Project < ApplicationRecord
  include ImageUploader::Attachment.new(:landscape)
  include ImageUploader::Attachment.new(:thumbnail)

  belongs_to :category
  validates :name, :short_description, :long_description, :target_amount, presence: true
end
