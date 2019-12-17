class ContributionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: :new

  def new
    @contribution = Contribution.new(user: current_user, project: @project)
    @counterparts = @project.counterparts
  end
  
  def create
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
