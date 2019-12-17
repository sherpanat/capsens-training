class ApplicationController < ActionController::Base
  include ExceptionHandling
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :birthdate])
  end
end
