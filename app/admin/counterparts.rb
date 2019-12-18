ActiveAdmin.register Counterpart do
  menu false
  actions :all, except: [:index, :show]
  permit_params :description, :threshold, :stock, :project_id

  form do |f|
    f.inputs do
      f.input :description
      f.input :threshold
      f.input :stock
      f.input :project, as: :select
    end
    f.actions do
      f.action :submit
    end
  end

  controller do
    def create
      if can_add_a_counterpart?
        super do |success, failure|
          success.html { redirect_to_project_show }
        end
      else
        @resource = Counterpart.new(permitted_params[:counterpart])
        @resource.errors.add(:project, t('.counterpart_creation_over'))
        render :new
      end
    end

    def update
      super do |success, failure|
        success.html { redirect_to_project_show }
      end
    end

    def destroy
      super do |success, failure|
        success.html { redirect_to_project_show }
      end
    end

    private
    
    def redirect_to_project_show
      redirect_to admin_project_path(resource.project)
    end

    def can_add_a_counterpart?
      project = Project.find(project_id)
      project.draft? || project.upcoming?
    end

    def project_id
      params.require(:counterpart).permit(:project_id)[:project_id]
    end
  end
end
