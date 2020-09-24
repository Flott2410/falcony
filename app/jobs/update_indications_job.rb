class UpdateIndicationsJob < ApplicationJob
  queue_as :default

  def perform
    require 'date'
    require 'open-uri'
    require 'csv'
    require 'json'

    countries = [["AUT", "Austria"], ["BEL", "Belgium"], ["BGR", "Bulgaria"], ["HRV", "Croatia"], ["CYP", "Cyprus"], ["CZE", "Czech Republic"], ["DNK", "Denmark"], ["EST", "Estonia"], ["FIN", "Finland"], ["FRA", "France"], ["DEU", "Germany"], ["GRC", "Greece"], ["HUN", "Hungary"], ["ISL", "Iceland"], ["IRL", "Ireland"], ["ITA", "Italy"], ["LVA", "Latvia"], ["LTU", "Lithuania"], ["LUX", "Luxembourg"], ["MLT", "Malta"], ["NLD", "Netherlands"], ["NOR", "Norway"], ["POL", "Poland"], ["PRT", "Portugal"], ["ROU", "Romania"], ["SVK", "Slovakia"], ["SVN", "Slovenia"], ["ESP", "Spain"], ["SWE", "Sweden"], ["CHE", "Switzerland"]]

    Indication.destroy_all

    # importing and parsing the csv file
    csv_options = { col_sep: ';', headers: :first_row, liberal_parsing: true }
    url =  "https://reopen.europa.eu/static/weekly-archive.csv"
    filepath = open(url)
    @csv_file = CSV.read(filepath, csv_options)

    @csv_file.each do |row|
      row[0] = Date.parse(row[0])
    end

    def select_row(category, indicator, country)
      unsorted_rows = @csv_file.select { |element| element[1] == country && element[4] == category.to_s && element[5] == indicator.to_s }
      sorted_rows = unsorted_rows.sort_by { |element| element[0] }
      sorted_rows.last
    end

    def open(country)
      select_row(2, 8, country)
    end

    def quarantine(country)
      select_row(2, 10, country)
    end

    def test(country)
      select_row(2, 11, country)
    end

    def masks_in_public(country)
      select_row(4, 2, country)
    end

    def physical_distancing(country)
      select_row(4, 3, country)
    end

    def health_protocols(country)
      select_row(4, 2, country)
    end

    def gatherings(country)
      select_row(4, 8, country)
    end

    def high_risk_areas(country)
      select_row(4, 1, country)
    end

    def tourism_accomodations(country)
      select_row(3, 2, country)
    end

    def restaurants(country)
      select_row(3, 3, country)
    end

    def bars_cafes(country)
      select_row(3, 4, country)
    end

    def beaches(country)
      select_row(3, 5, country)
    end

    def museums(country)
      select_row(3, 6, country)
    end

    def personal_services(country)
      select_row(3, 7, country)
    end

    def places_of_worship(country)
      select_row(3, 8, country)
    end

    def public_transportation(country)
      select_row(4, 5, country)
    end

    def get_description(name_of_indication)
      row = name_of_indication
      return "#{row[7]}"
    end

    def get_status(name_of_indication)
      row = name_of_indication
      return "#{row[6]}"
    end

    def get_category(name_of_indication)
      row = name_of_indication
      return "#{row[2]}"
    end

    countries.each do |country|
      Indication.create!(
          name: 'open',
          description: get_description(open(country[0])),
          status: get_status(open(country[0])),
          category: get_category(open(country[0])),
          country: Country.where(iso: country[0]).first
        )
       Indication.create!(
          name: 'quarantine',
          description: get_description(quarantine(country[0])),
          status: get_status(quarantine(country[0])),
          category: get_category(quarantine(country[0])),
          country: Country.where(iso: country[0]).first
        )
       Indication.create!(
          name: 'test',
          description: get_description(test(country[0])),
          status: get_status(test(country[0])),
          category: get_category(test(country[0])),
          country: Country.where(iso: country[0]).first
        )
       Indication.create!(
          name: 'masks_in_public',
          description: get_description(masks_in_public(country[0])),
          status: get_status(masks_in_public(country[0])),
          category: get_category(masks_in_public(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'physical_distancing',
          description: get_description(physical_distancing(country[0])),
          status: get_status(physical_distancing(country[0])),
          category: get_category(physical_distancing(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'health_protocols',
          description: get_description(health_protocols(country[0])),
          status: get_status(health_protocols(country[0])),
          category: get_category(health_protocols(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'gatherings',
          description: get_description(gatherings(country[0])),
          status: get_status(gatherings(country[0])),
          category: get_category(gatherings(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'high_risk_areas',
          description: get_description(high_risk_areas(country[0])),
          status: get_status(high_risk_areas(country[0])),
          category: get_category(high_risk_areas(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'tourism_accomodations',
          description: get_description(tourism_accomodations(country[0])),
          status: get_status(tourism_accomodations(country[0])),
          category: get_category(tourism_accomodations(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'restaurants',
          description: get_description(restaurants(country[0])),
          status: get_status(restaurants(country[0])),
          category: get_category(restaurants(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'bars_cafes',
          description: get_description(bars_cafes(country[0])),
          status: get_status(bars_cafes(country[0])),
          category: get_category(bars_cafes(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'beaches',
          description: get_description(beaches(country[0])),
          status: get_status(beaches(country[0])),
          category: get_category(beaches(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'museums',
          description: get_description(museums(country[0])),
          status: get_status(museums(country[0])),
          category: get_category(museums(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'personal_services',
          description: get_description(personal_services(country[0])),
          status: get_status(personal_services(country[0])),
          category: get_category(personal_services(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'places_of_worship',
          description: get_description(places_of_worship(country[0])),
          status: get_status(places_of_worship(country[0])),
          category: get_category(places_of_worship(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'public_transportation',
          description: get_description(public_transportation(country[0])),
          status: get_status(public_transportation(country[0])),
          category: get_category(public_transportation(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'get_description',
          description: get_description(get_description(country[0])),
          status: get_status(get_description(country[0])),
          category: get_category(get_description(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'get_status',
          description: get_description(get_status(country[0])),
          status: get_status(get_status(country[0])),
          category: get_category(get_status(country[0])),
          country: Country.where(iso: country[0]).first
        )
      Indication.create!(
          name: 'get_category',
          description: get_description(get_category(country[0])),
          status: get_status(get_category(country[0])),
          category: get_category(get_category(country[0])),
          country: Country.where(iso: country[0]).first
        )
    end
  end
end
