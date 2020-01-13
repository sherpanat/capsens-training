class ContributionsController < ApplicationController
  before_action :authenticate_user!
  decorates_assigned :project

  def new
    @project = get_project
    @contribution = Contribution.new(user: current_user, project: @project)
  end
  
  def create
    @project = get_project
    result = Contributions::CreateTransaction.call(contribution_params.merge(project: @project, user: current_user))
    if result.success
      redirect_to users_dashboards_path
    else
      @contribution = result.failure[:contribution]
      render :new
    end
  end

  private
  
  def contribution_params
    params.require(:contribution).permit(:amount, :counterpart_id)
  end

  def get_project
    Project.find(params[:project_id])
  end
end
