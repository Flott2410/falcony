class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :create_trip_from_session
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:photo, :first_name, :last_name, :phone_number, :email, :country_id, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:photo, :email, :password])
  end

  def create_trip_from_session
    # check if session variables exist and user signed in - if yes create trip
    if session[:create_trip_destination_id] && session[:create_trip_origin_id] && user_signed_in?
      Trip.create(
        origin_id: session[:create_trip_origin_id],
        destination_id: session[:create_trip_destination_id],
        user: current_user
        )
      session.delete(:create_trip_destination_id)
      session.delete(:create_trip_origin_id)
      # redirect_to trips_path
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end
  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
