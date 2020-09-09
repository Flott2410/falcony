class CountriesController < ApplicationController
skip_before_action :authenticate_user!, only: [ :show, :result, :index ]
before_action :set_countries_iso_alpha_2, only: [ :index, :show ]

  def index
    @countries = Country.all

    # set latest date the data was updated
    @update_date = @countries.sample.cases.last.date

    # define country iso code 3 array
    countries = ['AUT', "BEL", "BGR", "HRV", "CYP", "CZE", "DNK", "EST", "FIN", "FRA", "DEU", "GRC", "HUN", "ISL", "IRL", "ITA", "LVA", "LTU", "LUX", "MLT", "NLD", "NOR", "POL", "PRT", "ROU", "SVK", "SVN", "ESP", "SWE", "CHE"]

    # define total cases for use it in javascript map
    total_cases = []
    tmp_total_cases = Case.where(date: @update_date)
    tmp_total_cases.each do |item|
      total_cases << item.total_cases
    end
    # creates a hash with key value pairs iso-code and total cases
    # gon.total_cases = {"AUT"=>28495, "BEL"=>86450, ...
    gon.total_cases = countries.zip(total_cases).to_h

    # define new cases to use it in javascript map
    tmp_cases_per_country = Case.where(date: @update_date)
    new_cases = []
    tmp_cases_per_country.each do |item|
      if item.new_cases == nil
        item.new_cases = 0
      end
      new_cases << item.new_cases
    end
    gon.new_cases = countries.zip(new_cases).to_h

    # define death rate to use it in javascript map
    tmp_total_deaths = Case.where(date: @update_date)
    total_deaths = []
    tmp_total_deaths.each do |item|
      if item.total_deaths == nil
        item.total_deaths = 0
      end
      total_deaths << item.total_deaths
    end
    gon.total_deaths = countries.zip(total_deaths).to_h

    # define country ids
    country_ids = Country.all.map { |country| country.id }
    gon.country_ids = countries.zip(country_ids).to_h
  end

  def show
    @country = Country.find(params[:id])

    # Code for indication variables ############################################

    # open
    @open = Indication.where(country: @country).find_by(name: 'open')

    # quarantine
    @quarantine = Indication.where(country: @country).find_by(name: 'quarantine')

    # test
    @test = Indication.where(country: @country).find_by(name: 'test')

    # masks_in_public
    @masks_in_public = Indication.where(country: @country).find_by(name: 'masks_in_public')

    # physical_distancing
    @physical_distancing = Indication.where(country: @country).find_by(name: 'physical_distancing')

    # health_protocols
    @health_protocols = Indication.where(country: @country).find_by(name: 'health_protocols')

    # gatherings
    @gatherings = Indication.where(country: @country).find_by(name: 'gatherings')

    # high_risk_areas
    @high_risk_areas = Indication.where(country: @country).find_by(name: 'high_risk_areas')

    # tourism_accomodations
    @tourism_accomodations = Indication.where(country: @country).find_by(name: 'tourism_accomodations')

    # restaurants
    @restaurants = Indication.where(country: @country).find_by(name: 'restaurants')

    # bars_cafes
    @bars_cafes = Indication.where(country: @country).find_by(name: 'bars_cafes')

    # beaches
    @beaches = Indication.where(country: @country).find_by(name: 'beaches')

    # museums
    @museums = Indication.where(country: @country).find_by(name: 'museums')

    # personal_services
    @personal_services = Indication.where(country: @country).find_by(name: 'personal_services')

    # places_of_worship
    @places_of_worship = Indication.where(country: @country).find_by(name: 'places_of_worship')

    # public_transportation
    @public_transportation = Indication.where(country: @country).find_by(name: 'public_transportation')


    # Code for case variables ##################################################
    sum_1 = 0
    sum_2 = 0
    sum_3 = 0
    sum_4 = 0
    # set latest date the data was updated
    @update_date = @country.cases.last.date

    # Select all cases of the country of the last 14 days and build average
    cases_per_country_last_two_weeks = Case.where(country: @country).where(date: 14.days.ago..@update_date)
    cases_per_country_last_two_weeks.each do |item|
      if item.new_cases == nil
        sum_1 = 0
      else
        sum_1 += item.new_cases
      end
    end
    @last_two_weeks_average_new_cases = sum_1 / 14

    # Check if average of week - 2 is higher or lower than week -1
    cases_per_country_last_week = Case.where(country: @country).where(date: 7.day.ago..@update_date)
    cases_per_country_last_week.each do |item|
      if item.new_cases == nil
        sum_2 = 0
      else
        sum_2 += item.new_cases
      end
    end
    cases_per_country_last_week_avg = sum_2 / 7

    cases_per_country_prelast_week = Case.where(country: @country).where(date: 7.day.ago..14.day.ago) #.select()select update_date - 7 to - 14 days
    cases_per_country_prelast_week.each do |item|
      if item.new_cases == nil
        sum_3 = 0
      else
        sum_3 += item.new_cases
      end
    end
    cases_per_country_prelast_week_avg = sum_3 / 7

    if cases_per_country_last_week_avg < cases_per_country_prelast_week_avg
      @trend = true
    else
      @trend = false
    end

    # total_deaths per population
    deaths_pop_full = @country.cases.last.total_deaths / @country.cases.last.population.to_f * 100
    @deaths_pop = deaths_pop_full.round(3)
    @total_deaths = @country.cases.last.total_deaths
    @total_cases = @country.cases.last.total_cases
    @population = @country.cases.last.population
    @mortality = (@total_deaths * 100 / @population.to_f).round(3)
    @morbidity = (@total_deaths * 100 / @total_cases.to_f).round(3)


    # tests per case
    @tests_per_case = @country.cases.last.tests_per_case

    # new tests average from latest week
    new_tests_last_week = Case.where(country: @country).where(date: 7.day.ago..@update_date)
    new_tests_last_week.each do |item|
      if item.new_tests == nil
        sum_4 = 0
      else
        sum_4 += item.new_tests
      end
    end
    new_tests_last_week_avg_full = sum_4 / 7
    @new_tests_last_week_avg = new_tests_last_week_avg_full.round(2)

    # total tests
    @total_tests = @country.cases.last.total_tests

    # stringency index
    @stringency_index = @country.cases.last.stringency_index

    @single_country_values = []
    daily_cases = Case.where(country: @country).where(date: Date.parse('2020-01-01')..@update_date)
    daily_cases.each do |currentCase|
      var_name = @country.iso
      each_day = {}
      each_day = { 'date': currentCase['date'].strftime('%Y-%m-%d'), 'value': currentCase['new_cases'].nil? ? 0 : currentCase['new_cases'] }
      # each_day[:date] = covid_data['date']
      # each_day[:value] = covid_data['new_cases']
      @single_country_values << each_day
    end
    gon.daily_cases = @single_country_values
    # @single_country_data[var_name] = @single_country_values

  end

  def result
    @countries = Country.all
    @origin = Country.find(params[:country][:origin])
    @destination = Country.find(params[:country][:destination])
    @countries_wo_origin = @countries.reject{ |country| country == @origin }

    session[:create_trip_destination_id] = @destination.id
    session[:create_trip_origin_id] = @origin.id

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

    # create Trip instance for simple form - hidden (session parameters)
    @trip = Trip.new
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
      "Italia" => 'it',
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
