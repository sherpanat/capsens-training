class Counterpart < ApplicationRecord
  belongs_to :project

  valides :level, :threshold, presence: true
end
