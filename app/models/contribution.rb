class Contribution < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :counterpart, optional: true

  validates :amount, presence: true

  after_create :add_counterpart, if: :first_level_of_project_reached?
  
  def add_counterpart
    self.counterpart = counterpart_to_win if counterpart_to_win.available?
    save
  end

  def first_level_of_project_reached?
    project.first_level_reached?(amount)
  end

  private

  def counterpart_to_win
    project.counterparts.order(level: :desc).each do |counterpart|
      return counterpart if amount >= counterpart.threshold
    end
  end
end
