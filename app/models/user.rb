class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :contributions
  has_many :projects, through: :contributions

  validates :email, :first_name, :last_name, :birthdate, presence: true
end
