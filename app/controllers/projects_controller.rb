class ProjectsController < ApplicationController
  before_action :visible_projects, only: [:show, :index], unless: :current_admin_user
  before_action :all_projects, only: [:show, :index], if: :current_admin_user

  def index
    @projects = ProjectDecorator.decorate_collection(@projects)
  end

  def show
    @project = @projects.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  private

  def visible_projects
    @projects = Project.visibles
  end

  def all_projects
    @projects = Project.where.not(aasm_state: "failure")
  end
end
