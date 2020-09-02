class CountriesController < ApplicationController
skip_before_action :authenticate_user!, only: [ :show ]

  def show
    @country = Country.find(params[:id])
  end
end
