class ContributionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @project = set_project
    @contribution = Contribution.new(user: current_user, project: @project)
    @counterparts = set_counterparts
  end
  
  def create
    @project = set_project
    result = Contributions::CreateTransaction.call(contribution_params.merge(project: @project, user: current_user))
    if result.success
      redirect_to result.success[:card_attributes]["RedirectURL"]
    else
      @contribution = result.failure[:contribution]
      @counterparts = set_counterparts
      render :new
    end
  end

  private

  def set_project
    Project.find(params[:project_id])
  end

  def set_counterparts
    CounterpartDecorator.decorate_collection(@project.counterparts)
  end

  def contribution_params
    params.require(:contribution).permit(:amount, :counterpart_id)
  end
end
