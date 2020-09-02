class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :create_trip_from_session

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :email, :country_id, :password])
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
      redirect_to trips_path
    end
  end
end
