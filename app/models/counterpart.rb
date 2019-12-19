class Counterpart < ApplicationRecord
  belongs_to :project
  has_many :contributions

  validates :threshold, presence: true

  def description_with_threshold
    "#{description} : #{threshold}€"
  end
end
