class Counterpart < ApplicationRecord
  belongs_to :project
  has_many :contributions

  validates :threshold, presence: true
end
