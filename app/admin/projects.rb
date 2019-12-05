ActiveAdmin.register Project do
  permit_params :name, :short_description, :long_description, :target_amount, :category_id, :thumbnail, :landscape

  filter :category
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
      f.input :thumbnail, as: :file
      f.input :landscape, as: :file
    end
    f.actions
  end

  controller do
    def create
      if Project.create(project_params)
        redirect_to admin_projects_path
      else
        render :new
      end
    end

    def update
      project = Project.find(params[:id])
      project.update(project_params)
      redirect_to admin_project_path(project)
    end

    private

    def project_params
      params.require(:project).permit(:name, :short_description, :long_description, :target_amount, :category_id, :thumbnail, :landscape)
    end
  end
end

      # result = Users::CreateTransaction.call(sign_up_params)
      # if result.success
      #   @resource = result.success
      #   sign_up(resource_name, @resource)
      #   respond_with @resource, location: after_sign_up_path_for(@resource)        
      # else
      #   @resource = result.failure[:user]
      #   render :new


# controller do

#     def create
#       attrs = permitted_params[:firmware_image]

#       @firmware_image = FirmwareImage.create()

#       @firmware_image[:firmware_image_filename] = attrs[:firmware_image].original_filename
#       @firmware_image[:firmware_image] = attrs[:firmware_image].read

#       if @firmware_image.save
#         redirect_to admin_firmware_image_path(@firmware_image)
#       else
#         render :new
#       end
#     end

#     def update
#       attrs = permitted_params[:firmware_image]

#       @firmware_image = FirmwareImage.where(id: params[:id]).first!
#       @firmware_image.firmware_level = attrs[:firmware_level]

#       @firmware_image[:firmware_image_filename] = attrs[:firmware_image].original_filename
#       @firmware_image[:firmware_image] = attrs[:firmware_image].read

#       if @firmware_image.save
#         redirect_to admin_firmware_image_path(@firmware_image)
#       else
#         render :edit
#       end
#     end
#   end
