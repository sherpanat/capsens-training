class ContributionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @contribution = Contribution.new(user: current_user, project: set_project)
    set_counterparts
  end
  
  def create
    result = Contributions::CreateTransaction.call(contribution_params.merge(project: set_project, user: current_user))
    if result.success
      redirect_to new_payment_path(result.success)
    else
      @contribution = result.failure[:contribution]
      set_counterparts
      render :new
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_counterparts
    @counterparts = CounterpartDecorator.decorate_collection(@project.counterparts)
  end

  def contribution_params
    params.require(:contribution).permit(:amount, :counterpart_id)
  end
end
