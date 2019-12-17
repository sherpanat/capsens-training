ActiveAdmin.register Project do
  permit_params :name, :short_description, :long_description, :target_amount, :category_id, :thumbnail, :landscape
  decorate_with ProjectDecorator

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
    link_to t('.add_a_counterpart'), new_admin_counterpart_path
  end

  show do
    render 'show', project: project
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :short_description
      f.input :long_description
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
    def scoped_collection
      super.includes(contributions: :user)
    end
  end
end
