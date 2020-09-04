class CountriesController < ApplicationController
skip_before_action :authenticate_user!, only: [ :show, :result ]

  def show
    @country = Country.find(params[:id])
  end

  def result
    @countries = Country.all
    @origin = Country.find(params[:country][:origin])
    @destination = Country.find(params[:country][:destination])

    session[:create_trip_destination_id] = @destination.id
    session[:create_trip_origin_id] = @origin.id

    @destination_open = Indication.where(country: @destination).find_by(name: "open")
    @destination_high_risk_areas = Indication.where(country: @destination).find_by(name: "high_risk_areas")
    @destination_quarantine = Indication.where(country: @destination).find_by(name: "quarantine")
    @destination_test = Indication.where(country: @destination).find_by(name: "test")

    @destination_restaurants = Indication.where(country: @destination).find_by(name: "restaurants")
    @destination_bars_cafes = Indication.where(country: @destination).find_by(name: "bars_cafes")
    @destination_new_cases = Case.where(country: @destination).last.new_cases

    @origin_open = Indication.where(country: @origin).find_by(name: "open")
    @origin_quarantine = Indication.where(country: @origin).find_by(name: "quarantine")
    @origin_test = Indication.where(country: @origin).find_by(name: "test")

    # create Trip instance for simple form - hidden (session parameters)
    @trip = Trip.new
  end

end
