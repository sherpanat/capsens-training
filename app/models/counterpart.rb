class Counterpart < ApplicationRecord
  belongs_to :project
  has_many :contributions

  validates :level, :threshold, presence: true

  def available?
    stock > 0
  end
end
