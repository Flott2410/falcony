class TripsController < ApplicationController
before_action :set_trip, only: [ :show, :destroy ]

  def create
    # get trip variables from hidden for or not hidden form if user already sign in
    @trip = Trip.new(trip_params)
    # check if user is signed in
      # if yes create new trip
      @trip.user = current_user
      if @trip.save
        redirect_to trip_path(@trip)
      else
        render 'pages/home'
      end
    # else save origin and destination in session variable
    # option think about find or initialize by
    # assign user_id to trips if user is logged in

  end

  def index
    @trips = Trip.where(user: current_user).order(updated_at: :desc)

  end

  def show
  end

  def destroy
    @trip.destroy
    redirect_to trips_path

  end

  private

  def trip_params
    params.require(:trip).permit(:origin_id, :destination_id)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end
end
