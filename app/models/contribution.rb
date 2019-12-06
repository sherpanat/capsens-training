class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :contribution, presence: true
end
