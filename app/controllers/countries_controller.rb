class CountriesController < ApplicationController
skip_before_action :authenticate_user!, only: [ :show, :result ]

  def show
    @country = Country.find(params[:id])

    sum_1 = 0
    sum_2 = 0
    sum_3 = 0
    sum_4 = 0
    # set latest date the data was updated
    @update_date = @country.cases.last.date

    # Select all cases of the country of the last 14 days and build average
    cases_per_country_last_two_weeks = Case.where(country: @country)#.select() # select update_date - 14 days
    cases_per_country_last_two_weeks.each do |item|
      sum_1 += item.new_cases
    end
    @last_two_weeks_average_new_cases = sum_1 / 14

    # Check if average of week - 2 is higher or lower than week -1
    cases_per_country_last_week = Case.where(country: @country)#.select() # select update_date - 7 days
    cases_per_country_last_week.each do |item|
      sum_2 += item.new_cases
    end
    cases_per_country_last_week_avg = sum_2 / 7

    cases_per_country_prelast_week = Case.where(country: @country)#.select() # select update_date - 7 to - 14 days
    cases_per_country_prelast_week.each do |item|
      sum_3 += item.new_cases
    end
    cases_per_country_prelast_week_avg = sum_3 / 7

    if cases_per_country_last_week_avg < cases_per_country_prelast_week_avg
      @trend = true
    else
      @trend = false
    end

    # total_deaths per population
    @deaths_pop = @country.cases.last.total_deaths / @country.cases.last.population

    # tests per case
    @tests_per_case = @country.cases.last.tests_per_case

    # new tests average from latest week
    new_tests_last_week = Case.where(country: @country)#.select() # select update_date - 7 days
    new_tests_last_week.each do |item|
      sum_4 += item.new_tests
    end
    @new_tests_last_week_avg = sum_4 / 7

    # total tests
    @total_tests = @country.cases.last.total_tests

    # stringency index
    @stringency_index = @country.cases.last.stringency_index

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
