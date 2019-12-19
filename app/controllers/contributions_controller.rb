class ContributionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @contribution = Contribution.new(user: current_user, project: set_project)
    set_counterparts
  end
  
  def create
    contribution = Contribution.new(contribution_params.merge(project_id: params[:project_id], user: current_user))
    if contribution.save
      redirect_to users_dashboards_path
    else
      @contribution = contribution
      set_project
      set_counterparts
      render :new
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_counterparts
    @counterparts = @project.counterparts
  end

  def contribution_params
    params.require(:contribution).permit(:amount, :counterpart_id)
  end
end
