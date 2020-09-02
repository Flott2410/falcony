class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    # Create a new instance of trip on home page to send the form results to the trip controller
    @trip = Trip.new
  end
end

