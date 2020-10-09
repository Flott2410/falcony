class TripsController < ApplicationController
  before_action :set_trip, only: [ :show, :update, :destroy, :get_notified, :disable_notifications ]
  before_action :set_countries_iso_alpha_2, only: [ :show ]

  def create
    # get trip variables from hidden for or not hidden form if user already sign in
    @trip = Trip.new(trip_params)
    # check if user is signed in
    # if yes create new trip

    @trip.user = current_user
    if @trip.save
      redirect_to trips_path
    else
      render 'pages/home'
    end
    # else save origin and destination in session variable
  end

  def index
    @trips = Trip.where(user: current_user).where(bookmarked: true).order(updated_at: :desc)
  end

  def show
    # raise
    @origin = @trip.origin
    @destination = @trip.destination

    @destination_open = Indication.where(country: @destination).find_by(name: "open")
    @destination_high_risk_areas = Indication.where(country: @destination).find_by(name: "high_risk_areas")
    @destination_quarantine = Indication.where(country: @destination).find_by(name: "quarantine")
    @destination_test = Indication.where(country: @destination).find_by(name: "test")

    @destination_restaurants = Indication.where(country: @destination).find_by(name: "restaurants")
    @destination_bars_cafes = Indication.where(country: @destination).find_by(name: "bars_cafes")
    @destination_new_cases = Case.where(country: @destination).last.new_cases

    @destination_gatherings = Indication.where(country: @destination).find_by(name: "gatherings")
    @destination_museums = Indication.where(country: @destination).find_by(name: "museums")

    @origin_open = Indication.where(country: @origin).find_by(name: "open")
    @origin_quarantine = Indication.where(country: @origin).find_by(name: "quarantine")
    @origin_test = Indication.where(country: @origin).find_by(name: "test")
  end

  def update
    if @trip.bookmarked.nil?
      bookmark
    elsif @trip.bookmarked == true
      unbookmark
    else
      bookmark
    end
    @trip.save
    redirect_to trip_path(@trip)
  end

  def destroy
    @trip.destroy
    redirect_to trips_path
  end

  # Add a notification to a trip
  def get_notified
    @trip.update(trip_params)
    @trip.update(notify: true)
    @trip.save
    redirect_to trips_path, notice: 'Notification added'
  end

  def disable_notifications
    @trip.notifications.all.destroy_all
    @trip.new_daily_cases_threshold = 0
    @trip.notify = false
    @trip.save
    redirect_to trips_path, alert: 'Notification removed'
  end

  private

  def trip_params
    params.require(:trip).permit(:origin_id, :destination_id, :new_daily_cases_threshold)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def bookmark
    @trip.bookmarked = true
    @trip.save
  end

  def unbookmark
    @trip.bookmarked = false
    @trip.save
  end

  private

  def set_countries_iso_alpha_2
    @alpha_codes = {
      "Austria" => 'at',
      "Belgium" => 'be',
      "Bulgaria" => 'bg',
      "Croatia" => 'hr',
      "Cyprus" => 'cy',
      "Czech Republic" => 'cz',
      "Denmark" => 'dk',
      "Estonia" => 'ee',
      "Finland" => 'fi',
      "France" => 'fr',
      "Germany" => 'de',
      "Greece" => 'gr',
      "Hungary" => 'hu',
      "Iceland" => 'is',
      "Ireland" => 'ie',
      "Italy" => 'it',
      "Latvia" => 'lv',
      "Lithuania" => 'lt',
      "Luxembourg" => 'lu',
      "Malta" => 'mt',
      "Netherlands" => 'nl',
      "Norway" => 'no',
      "Poland" => 'pl',
      "Portugal" => 'pt',
      "Romania" => 'ro',
      "Slovakia" => 'sk',
      "Slovenia" => 'si',
      "Spain" => 'es',
      "Sweden" => 'se',
      "Switzerland" => 'ch'
    }
  end
end
