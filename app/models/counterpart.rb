class Counterpart < ApplicationRecord
  belongs_to :project

  validates :level, :threshold, presence: true
end
