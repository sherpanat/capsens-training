class ProjectsController < ApplicationController
  before_action :authenticate_admin_user!, only: :show, if: :draft_project?

  def index
    @projects = Project.visibles
  end

  def show
    @project ||= Project.find(params[:id])
  end

  private

  def draft_project?
    @project = Project.find(params[:id])
    @project.draft?
  end
end
