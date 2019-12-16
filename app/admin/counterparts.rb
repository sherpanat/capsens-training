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
    before_action :raise_404, unless: :can_add_counterpart?, only: :new

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
    
    def raise_404
      raise ActionController::RoutingError
    end

    def can_add_counterpart?
      resource.draft? || resource.upcoming?
    end
  end
end
