class TripsController < ApplicationController
skip_before_action :authenticate_user!, only: [ :create, :show ]
before_action :set_trip, only: [ :show ]

  def create
    @trip = Trip.new(trip_params)
    # assign user_id to trips if user is logged in
    @trip.user = current_user
    if @trip.save
      redirect_to trip_path(@trip)
    else
      render 'pages/home'
    end
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
