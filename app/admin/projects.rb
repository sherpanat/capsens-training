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

  action_item :new, only: :show do
    link_to t('.add_a_counterpart'), new_admin_counterpart_path if resource.draft? || resource.upcoming?
  end

  show do |project|
    columns do
      column do
        span t('.percentage_of_completion', percentage: project.decorate.percentage_of_completion)
      end
      column do
        span t('.total_invested', amount: project.decorate.amount_invested)
      end
      column do
        span t('.higher_contribution', amount: project.contributions.order(amount: :desc).first&.amount)
      end
      column do
        span t('.lower_contribution', amount: project.contributions.order(amount: :desc).first&.amount)
      end
    end

    panel t('.current_contributions') do
      table_for project.contributions do
        column t('.contributors_list') do |contribution|
          link_to contribution.user.decorate.full_name, admin_user_path(contribution.user)
        end
        column t('.amount_invested'), :amount
        column t('.chosen_counterpart') do |contribution|
          contribution.counterpart&.description
        end
        column t('.investment_date'), :created_at
      end
    end

    panel t('.counterparts') do
      table_for project.counterparts do
        column t('.counterpart_description'), :description
        column t('.counterpart_price'), :threshold
        column t('.edit') do |counterpart|
          link_to t('.edit'), edit_admin_counterpart_path(counterpart)
        end
        column t('.delete') do |counterpart|
          link_to t('.delete'), admin_counterpart_path(counterpart), method: :delete
        end
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
end
