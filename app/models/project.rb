class Project < ApplicationRecord
  include ImageUploader::Attachment.new(:landscape)
  include ImageUploader::Attachment.new(:thumbnail)
  include Aasm::Project

  scope :visibles, ->() do
    where(aasm_state: "ongoing").or(self.where(aasm_state: "upcoming")).or(self.where(aasm_state: "success"))
  end

  belongs_to :category, optional: true
  has_many :contributions
  has_many :contributors, through: :contributions, source: :user
  has_many :counterparts

  validates :name, :target_amount, presence: true
end
