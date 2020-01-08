module Users
  class RegistrationsController < Devise::RegistrationsController
    def new
      @resource = User.new
    end

    def create
      result = Users::CreateTransaction.call(sign_up_params)
      if result.success
        @resource = result.success[:user]
        sign_up(resource_name, @resource)
        respond_with @resource, location: after_sign_up_path_for(@resource)
      else
        @resource = result.failure[:user]
        render :new
      end
    end
  end
end
