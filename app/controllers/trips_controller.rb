class TripsController < ApplicationController
before_action :set_trip, only: [ :show ]

  def create
    # get trip variables from hidden for or not hidden form if user already sign in
    @trip = Trip.new(trip_params)
    # check if user is signed in
    if user_signed_in?
      # if yes create new trip
      @trip.user = current_user
      if @trip.save
        redirect_to trip_path(@trip)
      else
        render 'pages/home'
      end
    # else save origin and destination in session variable
    else
      session[:create_trip_destination_id] = @trip.destination.id
      session[:create_trip_origin_id] = @trip.origin.id
      redirect_to new_user_session_path
    end
    # option think about find or initialize by
    # assign user_id to trips if user is logged in

  end

  def index
    @trips = Trip.where(user: current_user)

  end

  def show
  end

  private

  def trip_params
    params.require(:trip).permit(:origin_id, :destination_id)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end
end
