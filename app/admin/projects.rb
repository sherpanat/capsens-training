ActiveAdmin.register Project do
  permit_params :name, :short_description, :long_description, :email, :owner_first_name, :owner_last_name, :owner_birthdate, :target_amount, :category_id, :thumbnail, :landscape
  decorate_with ProjectDecorator

  scope :all, default: true
  scope :draft
  scope :upcoming
  scope :ongoing
  scope :success
  scope :failure

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

  action_item :new, only: :show do
    link_to t('.add_a_counterpart'), new_admin_counterpart_path if resource.draft? || resource.upcoming?
  end
  
  action_item :preview, only: :show do
    link_to t('.preview'), project_path(resource), target: '_blank'
  end

  action_item :prepare, only: :show do
    link_to t('.prepare'), prepare_admin_project_path(resource) if resource.may_prepare?
  end
  
  member_action :prepare do
    resource.prepare!
    redirect_to admin_project_path(resource)
  end
  
  action_item :publish, only: :show do
    link_to t('.publish'), publish_admin_project_path(resource) if resource.may_publish?
  end
    
  member_action :publish do
    resource.publish!
    redirect_to admin_project_path(resource)
  end
  
  action_item :end_collect, only: :show do
    link_to t('.end_collect'), end_collect_admin_project_path(resource) if resource.may_end_collect?
  end
  
  member_action :end_collect do
    resource.end_collect!
    redirect_to admin_project_path(resource)
  end

  show do
    render 'show', project: project
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :short_description
      f.input :long_description
      f.input :email
      f.input :owner_first_name
      f.input :owner_last_name
      f.input :owner_birthdate
      f.input :target_amount
      f.input :category, as: :select
      f.input(
        :thumbnail,
        as: :file,
        hint: f.object.thumbnail.present? ? image_tag(f.object.thumbnail.url) : content_tag(:span, t('.no_image_yet'))
      )
      f.input(
        :landscape,
        as: :file,
        hint: f.object.landscape.present? ? image_tag(f.object.landscape.url) : content_tag(:span, t('.no_image_yet'))
      )
    end
    f.actions
  end
  
  controller do
    def create
      result = Projects::CreateTransaction.call(permitted_params[:project])
      if result.success
        @resource = result.success[:project]
        redirect_to admin_project_path(@resource)
      else
        @resource = result.failure[:project]
        render :new
      end
    end

    def scoped_collection
      super.includes(contributions: :user)
    end
  end
end
