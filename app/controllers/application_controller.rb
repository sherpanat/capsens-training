class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :birthdate])
  end

  def render_not_found
    render :file => "#{Rails.root}/public/404.html",  :status => 404
  end
end
