class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :create_trip_from_session, if: :devise_controller?
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:photo, :first_name, :last_name, :phone_number, :email, :country_id, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:photo, :email, :password])
  end

  # def after_database_authentication
  # def create_trip_from_session
  #   # check if session variables exist and user signed in - if yes create trip
  #   if session[:create_trip_destination_id] && session[:create_trip_origin_id] && user_signed_in?
  #     @trip = Trip.create(
  #       origin_id: session[:create_trip_origin_id],
  #       destination_id: session[:create_trip_destination_id],
  #       user: current_user,
  #       bookmarked: true
  #       )
  #     session.delete(:create_trip_destination_id)
  #     session.delete(:create_trip_origin_id)
  #     redirect_to trip_path(@trip)
  #   end
  # end

  def after_sign_in_path_for(resource)
  stored_location_for(resource) ||
    if resource.is_a?(User) && session[:create_trip_destination_id] && session[:create_trip_origin_id]
      @trip = Trip.create(
        origin_id: session[:create_trip_origin_id],
        destination_id: session[:create_trip_destination_id],
        user: resource,
        bookmarked: true
        )
      session.delete(:create_trip_destination_id)
      session.delete(:create_trip_origin_id)
      trip_path(@trip)
    else
      super
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

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
end
