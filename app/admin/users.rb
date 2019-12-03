ActiveAdmin.register User do
  permit_params :first_name, :last_name, :birthdate, :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :created_at
    column :updated_at
    column :sign_in_count
    column :current_sign_in_at
    column :current_sign_in_ip
    actions
  end

  show do |user|
    attributes_table do
      User.column_names.each do |column|
        row column
      end
    end
    active_admin_comments
  end

  action_item :login_as, only: :show do
    link_to 'Log as User', login_as_admin_user_path(user), :target => '_blank'
  end

  member_action :login_as do
    user = User.find(params[:id])
    bypass_sign_in(user)
    redirect_to root_path
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :created_at
  filter :current_sign_in_at
  filter :sign_in_count

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :birthdate, as: :datepicker
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end
end
