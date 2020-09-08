class CountriesController < ApplicationController
skip_before_action :authenticate_user!, only: [ :show, :result ]
before_action :set_countries_iso_alpha_2, only: [ :index, :show ]

  def index
    @countries = Country.all

    # set latest date the data was updated
    @update_date = @countries.sample.cases.last.date

    total_cases = []
    tmp_total_cases = Case.where(date: @update_date)
    tmp_total_cases.each do |item|
      total_cases << item.total_cases
    end
    countries = ['AUT', "BEL", "BGR", "HRV", "CYP", "CZE", "DNK", "EST", "FIN", "FRA", "DEU", "GRC", "HUN", "ISL", "IRL", "ITA", "LVA", "LTU", "LUX", "MLT", "NLD", "NOR", "POL", "PRT", "ROU", "SVK", "SVN", "ESP", "SWE", "CHE"]
    gon.total_cases = countries.zip(total_cases).to_h

    # gon.total_cases = {"AUT"=>28495, "BEL"=>86450, "BGR"=>16617, "HRV"=>11094, "CYP"=>1498, "CZE"=>26452, "DNK"=>17374, "EST"=>2128, "FIN"=>2444, "FRA"=>8200, "DEU"=>300181, "GRC"=>246948, "HUN"=>10998, "ISL"=>6923, "IRL"=>29206, "ITA"=>272912, "LVA"=>1410, "LTU"=>2978, "LUX"=>6745, "MLT"=>1965, "NLD"=>72392, "NOR"=>11035, "POL"=>69129, "PRT"=>59051, "ROU"=>91256, "SVK"=>4163, "SVN"=>3041, "ESP"=>84729, "SWE"=>43127, "CHE"=>nil}
    # gon.new_cases_last_week =
    # gon.deaths_pop =
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
