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
end
