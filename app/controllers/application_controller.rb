class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:photo, :first_name, :last_name, :phone_number, :email, :country_id, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:photo, :email, :password])
  end
end
