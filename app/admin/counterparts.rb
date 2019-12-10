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
      super { redirect_to_project_show and return if resource.valid? }
    end

    def update
      super { redirect_to_project_show and return if resource.valid? }
    end

    def destroy
      super { redirect_to_project_show and return if resource.valid? }
    end

    private
    
    def redirect_to_project_show
      redirect_to admin_project_path(resource.project)
    end
  end
end
