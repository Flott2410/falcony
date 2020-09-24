class UpdateCasesJob < ApplicationJob
  queue_as :default

  def perform
    require 'date'
    require 'open-uri'
    require 'csv'
    require 'json'

    countries = [["AUT", "Austria"], ["BEL", "Belgium"], ["BGR", "Bulgaria"], ["HRV", "Croatia"], ["CYP", "Cyprus"], ["CZE", "Czech Republic"], ["DNK", "Denmark"], ["EST", "Estonia"], ["FIN", "Finland"], ["FRA", "France"], ["DEU", "Germany"], ["GRC", "Greece"], ["HUN", "Hungary"], ["ISL", "Iceland"], ["IRL", "Ireland"], ["ITA", "Italy"], ["LVA", "Latvia"], ["LTU", "Lithuania"], ["LUX", "Luxembourg"], ["MLT", "Malta"], ["NLD", "Netherlands"], ["NOR", "Norway"], ["POL", "Poland"], ["PRT", "Portugal"], ["ROU", "Romania"], ["SVK", "Slovakia"], ["SVN", "Slovenia"], ["ESP", "Spain"], ["SWE", "Sweden"], ["CHE", "Switzerland"]]
    # Case.destroy_all

    url = 'https://covid.ourworldindata.org/data/owid-covid-data.json'
    cases_serialized = open(url).read
    cases = JSON.parse(cases_serialized)

    countries.each do |country|
      # iso code: country[0]
      cases[country[0]]['data'].each do |covid_data|
        # only create new cases for dates that doesn't yet exist in the database
        date = Date.parse(covid_data['date'])
        if date > Case.last.date
        Case.create!(
          date: date,
          country: Country.find_by(iso: country[0]),
          total_cases: covid_data['total_cases'],
          new_cases: covid_data['new_cases'],
          total_deaths: covid_data['total_deaths'],
          new_deaths: covid_data['new_deaths'],
          population: cases[country[0]]['population'],
          total_tests: covid_data['total_tests'],
          new_tests: covid_data['new_tests'],
          tests_per_case: covid_data['tests_per_case'],
          stringency_index: covid_data['stringency_index']
        )
        end
      end
    end
  end
end
