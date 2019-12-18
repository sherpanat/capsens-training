class ProjectsController < ApplicationController
  def index
    current_admin_user ? all_projects : visible_projects
    @projects = ProjectDecorator.decorate_collection(@projects)
  end

  def show
    current_admin_user ? all_projects : visible_projects
    @project = @projects.find(params[:id])
  end

  private

  def visible_projects
    @projects = Project.visibles
  end

  def all_projects
    @projects = Project.where.not(aasm_state: "failure")
  end
end
