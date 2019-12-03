class Project < ApplicationRecord
  belongs_to :category
  validates :name, :short_description, :long_description, :target_amount, presence: true
end
