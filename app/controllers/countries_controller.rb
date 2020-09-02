class CountriesController < ApplicationController
skip_before_action :authenticate_user!, only: [ :show, :result ]

  def show
    @country = Country.find(params[:id])
  end

  def result
    @countries = Country.all
    @origin = Country.find(params[:country][:origin])
    @destination = Country.find(params[:country][:destination])
    # create Trip instance for simple form - hidden (session parameters)
    @trip = Trip.new
  end

end
