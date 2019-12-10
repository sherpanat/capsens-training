ActiveAdmin.register Project do
  permit_params :name, :short_description, :long_description, :target_amount, :category_id, :thumbnail, :landscape

  index do
    selectable_column
    column :name
    column :target_amount
    column :created_at
    actions
  end

  filter :name
  filter :target_amount
  filter :created_at

  show do |project|
    columns do
      column do
        span "Pourcentage de completion : #{project.decorate.percentage_of_completion}"
      end
      column do
        span "Total collecté : #{project.decorate.amount_invested}"
      end
      column do
        span "Contribution la plus haute : #{project.contributions.order(amount: :desc).first.amount}"
      end
      column do
        span "Contribution la plus basse : #{project.contributions.order(amount: :desc).last.amount}"
      end
    end


    panel "Contributions actuelles" do
      table_for project.contributions do
        column "Liste des investisseurs" do |contribution|
          link_to contribution.user.decorate.full_name, admin_user_path(contribution.user)
        end
        column :amount
        column "Montant investi" do |contribution|
          contribution.amount
        end
        column :counterpart do |contribution|
          contribution.counterpart&.description
        end
        column :created_at
      end
    end

    attributes_table do
      row :name
      row :short_description
      row :long_description
      row :target_amount
      row :category
      row :created_at
      row :update_at
      row :thumbnail do
        image_tag project.thumbnail_url if project.thumbnail
      end
      row :landscape do
        image_tag project.landscape_url if project.landscape
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :short_description
      f.input :long_description
      f.input :target_amount
      f.input :category, as: :select
      f.input :thumbnail, as: :file,
        hint: f.object.thumbnail.present? ? image_tag(f.object.thumbnail.url) : content_tag(:span, t('.no_image_yet'))
      f.input :landscape, as: :file,
        hint: f.object.landscape.present? ? image_tag(f.object.landscape.url) : content_tag(:span, t('.no_image_yet'))
    end
    f.actions
  end

  controller do
    def create(options = {}, &block)
      project = Project.new(project_params)
      if project.save
        redirect_to admin_projects_path
      else
        super(options) do |success, failure|
          block.call(success, failure) if block
          failure.html { render :new }
        end
      end
    end

    def update(options = {}, &block)
      project = Project.find(params[:id])
      if project.update(project_params)
        redirect_to admin_project_path(project)
      else
        super(options) do |success, failure|
          block.call(success, failure) if block
          failure.html { render :edit }
        end
      end
    end

    private

    def project_params
      params.require(:project).permit(:name, :short_description, :long_description, :target_amount, :category_id, :thumbnail, :landscape)
    end
  end
end
