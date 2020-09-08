# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require 'date'
require 'open-uri'
require 'csv'
require 'json'

# consider refactoring and separate seeds into separate files
# require_relative './_indications'

puts "destroy all ..."
Country.destroy_all
Case.destroy_all
Indication.destroy_all
User.destroy_all
Trip.destroy_all
# Order of creation of seed: 1.countries, 2.cases, 3.indications, 4.users, 5.trips

# Countries_____________________________________________________________________

# Constant with all countries
countries = [["AUT", "Austria"], ["BEL", "Belgium"], ["BGR", "Bulgaria"], ["HRV", "Croatia"], ["CYP", "Cyprus"], ["CZE", "Czech Republic"], ["DNK", "Denmark"], ["EST", "Estonia"], ["FIN", "Finland"], ["FRA", "France"], ["DEU", "Germany"], ["GRC", "Greece"], ["HUN", "Hungary"], ["ISL", "Iceland"], ["IRL", "Ireland"], ["ITA", "Italia"], ["LVA", "Latvia"], ["LTU", "Lithuania"], ["LUX", "Luxembourg"], ["MLT", "Malta"], ["NLD", "Netherlands"], ["NOR", "Norway"], ["POL", "Poland"], ["PRT", "Portugal"], ["ROU", "Romania"], ["SVK", "Slovakia"], ["SVN", "Slovenia"], ["ESP", "Spain"], ["SWE", "Sweden"], ["CHE", "Switzerland"]]

# For loop that creates a country instance using the strings in the countries constant
puts 'Generating countries...'

countries.each do |country|
  Country.create!(name: country[1], iso: country[0])
end

puts "Countries created ;-)"

# Cases   ______________________________________________________________________

puts 'Generating cases...'

# parsing the json file
url = 'https://covid.ourworldindata.org/data/owid-covid-data.json'
cases_serialized = open(url).read
cases = JSON.parse(cases_serialized)

countries.each do |country|
  # iso code: country[0]
  cases[country[0]]['data'].each do |covid_data|
    date = Date.parse(covid_data['date'])
    if date > Date.new(2020, 7, 1)
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

puts "Cases created ;-)"

# Previous fake code to create fake cases ____________________________

# current_day = Date.today
# day_zero = Date.new(2020, 8, 1)
# days_since_day_zero = (current_day - day_zero).to_i

# Country.all.each do |country|
#   Case.create!(
#     date: day_zero.strftime('%Y-%m-%d'),
#     country_id: country.id, # random from the length of countries
#     total_cases: 0,
#     new_cases: 0,
#     total_deaths: 0,
#     new_deaths: 0,
#     population: rand(1_000_000..1_000_000_000),
#     total_tests: 0,
#     new_tests: 0,
#     tests_per_case: 0.0, # float
#     stringency_index: 0 # from 0 to 100. 100 being the strictest
#     )
# end


# # The following seed will take the values from the seed above and update them
# # Create seeds from all days since 2020-01-01
# day = 1
# days_since_day_zero.times do


#   # Create new data starting from the previous seed with new daily value
#   Country.all.each do |country|
#     previous_case = Case.where(country_id: country.id).last
#     Case.create!(
#       date: (day_zero + day).strftime('%Y-%m-%d'),
#       country_id: country.id, # random from the length of countries
#       total_cases: previous_case.total_cases + rand(0..100),
#       new_cases: previous_case.new_cases + rand(0..100),
#       total_deaths: previous_case.total_deaths + rand(0..100),
#       new_deaths: previous_case.new_deaths + rand(0..50),
#       population: previous_case.population,
#       total_tests: previous_case.total_tests + rand(0..1000),
#       new_tests: previous_case.new_tests + rand(0..1000),
#       tests_per_case: previous_case.tests_per_case + rand(0.0..1000.0),
#       stringency_index: rand(0..100)
#       )
#   end
#   day += 1 # go to the next day.
# end

# puts "Cases created ;-)"

# Users ______________________________________________________________________
# Don't forget to add images

# Create 4 static users that we can always count on for tests

puts 'Generating 4 static users...'
kleyv = User.new(
  first_name: 'Eukleyv',
  last_name: 'Smith',
  phone_number: '+351927691750',
  email: 'eukleyvcardoso@gmail.com',
  password: '123456',
  country_id: Country.find_by(name: 'Portugal').id
  )
file = URI.open('https://kitt.lewagon.com/placeholder/users/kleyv')
kleyv.photo.attach(io: file, filename: 'kleyv_avatar.png', content_type: 'image/png')
kleyv.save!

florian = User.new(
  first_name: 'Florian',
  last_name: 'Ott',
  phone_number: '+436605633993',
  email: 'florian.ott@gmx.at',
  password: '123456',
  country_id: Country.find_by(name: 'Austria').id
  )
file = URI.open('https://kitt.lewagon.com/placeholder/users/Flott2410')
florian.photo.attach(io: file, filename: 'florian_avatar.png', content_type: 'image/png')
florian.save!

raffaelle = User.new(
  first_name: 'Raffaele',
  last_name: 'Viggiani',
  phone_number: '+393356284820',
  email: 'raffaele.viggiani@gmail.com',
  password: '123456',
  country_id: Country.find_by(name: 'Italia').id
  )
file = URI.open('https://kitt.lewagon.com/placeholder/users/raffoz')
raffaelle.photo.attach(io: file, filename: 'raffaelle_avatar.png', content_type: 'image/png')
raffaelle.save!

tiago = User.new(
  first_name: 'Tiago',
  last_name: 'Palhoca',
  phone_number: '+351919412637',
  email: 'palhoca.tiago@gmail.com',
  password: '123456',
  country_id: Country.find_by(name: 'Portugal').id
  )
file = URI.open('https://kitt.lewagon.com/placeholder/users/Tiago-Palhoca')
tiago.photo.attach(io: file, filename: 'tiago_avatar.png', content_type: 'image/png')
tiago.save
puts "Users created ;-)"

# Trips

# puts 'Generating trips...'
# # A for loop to create all possible trips
# for country_a in countries
#   # create countries_prime that contains all countries except the origin country so the origin isn't equal to the destination
#   countries_prime = countries.reject{ |country|
#       country == country_a
#     }
#   for country_b in countries_prime
#     Trip.create!(
#       origin: Country.find_by(name: country_a), # get origin from coutries array
#       destination: Country.find_by(name: country_b), # get destination from countries_prime array
#       user: User.all.sample,
#       bookmarked: [true, false].sample
#       )
#   end
# end

puts "Trips created ;-)"

# Indications____________________________________________________________________

# old files from first indications

# Indication.create!(
#   country: Country.first,
#   category: 'Travel',
#   name: 'open',
#   description: 'Entering from a country with a stable COVID-19 situation&nbsp;is possible without restrictions.</p><p>Currently, travelling to and from EU countries is allowed without restrictions, with the exception of <strong>Portugal</strong>, <strong>Sweden</strong>, <strong>Bulgaria</strong> and <strong>Romania</strong>.<br />Travelling to and from Norway, Switzerland, Iceland and Liechtenstein, as well as Andorra, Monaco, Vatican City State and the Republic of San Marino, is allowed without restrictions.</p><p>When&nbsp;entering from a country in which there is no stable COVID-19 situation,&nbsp;entry is possible with a health certificate&nbsp;(<a href="https://www.sozialministerium.at/dam/jcr:34b1ed5c-5135-473c-b41a-85f42bd673be/336.%20Verordnung%20-%20Anlage%20C.pdf">Annex C</a>).&nbsp;<br /><br /><strong>Rules and Exceptions</strong><br />The prerequisite&nbsp;to enter Austria is that the traveller has&nbsp;only resided in countries with a stable COVID-19 situation in the past ten days&nbsp;and is resident or habitually resident in Austria or in one of these countries.</p><p>Entry from a country with a stable COVID-19 situation is possible without restrictions. The corresponding countries are listed in <a href="https://www.sozialministerium.at/dam/jcr:17bc058c-811f-48e7-95d0-56eb43f1bad4/336.%20Verordnung%20-%20Anlage%20A1.pdf">Appendix A1</a> of the Entry Ordinance and are currently (as of 27.07.2020): Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Croatia, Latvia, Liechtenstein, Lithuania, Luxembourg, Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain, Czech Republic, Hungary, Vatican, United Kingdom and Cyprus.<br />If the person has also been in other countries within the last 10 days, entry is possible either with a medical certificate confirming a negative PCR test (performed within 72 hours prior to entry) or by undergoing a 10-day (home) quarantine. A confirmation of accommodation must be presented and any costs incurred must be paid for by yourself. Quarantine can be terminated if a PCR test performed during the period is negative.</p><p><strong>Children up to the age of 6</strong>&nbsp;are exempt from compulsory testing upon entry.</p><p><strong>Mandatory Travel Documentation</strong><br />No<br /><br /><strong>Specific measures for Austrian citizens returning to Austria</strong></p><p>Country specific travel information are available at&nbsp;<a href="https://www.bmeia.gv.at/reise-aufenthalt/reiseinformation/laender/">www.bmeia.gv.at</a></p><p>Entry from a country with a stable COVID-19 situation is possible without restrictions. The corresponding countries are listed in <a href="https://www.sozialministerium.at/dam/jcr:17bc058c-811f-48e7-95d0-56eb43f1bad4/336.%20Verordnung%20-%20Anlage%20A1.pdf">Appendix A1</a> of the Entry Ordinance and are currently (as of 27.07.2020): Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Croatia, Latvia, Liechtenstein, Lithuania, Luxembourg, Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain, Czech Republic, Hungary, Vatican, United Kingdom and Cyprus.<br />If the person has also been in other countries within the last 10 days, entry is possible either with a medical certificate confirming a negative PCR test (performed within 72 hours prior to entry) or by undergoing a 10-day (home) quarantine. A confirmation of accommodation must be presented and any costs incurred must be paid for by yourself. Quarantine can be terminated if a PCR test performed during the period is negative.</p><p><strong>Children up to the age of 6</strong>&nbsp;are exempt from compulsory testing upon entry.<br /><br /><strong>Links to relevant national sources</strong><br /><a href="https://www.sozialministerium.at/Informationen-zum-Coronavirus/Coronavirus---Haeufig-gestellte-Fragen/FAQ--Reisen-und-Tourismus.html">FAQs on travel and tourism (www.sozialministerium.at)</a><br /><a href="https://www.bmeia.gv.at/reise-aufenthalt/reiseinformation/laender/">www.bmeia.gv.at</a></p><p>&nbsp;',
#   status: 'WL'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Travel',
#   name: 'quarantine',
#   description: 'Travellers from the following countries can enter or leave Austria without restrictions: Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Croatia, Latvia, Liechtenstein, Lithuania, Luxembourg , Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain, Czech Republic, Hungary, Vatican, Great Britain and Cyprus. The regulation applies only to people who are residents in the listed countries or Austrian citizens. It is also a prerequisite that you have not been in any country other than Austria or those European countries in the past 10 days. You can find the latest provisions here: <a href="https://www.sozialministerium.at">www.sozialministerium.at</a>',
#   status: 'WL'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Travel',
#   name: 'test',
#   description: 'Travellers from the following countries can enter or leave Austria without restrictions: Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Croatia, Latvia, Liechtenstein, Lithuania, Luxembourg , Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain, Czech Republic, Hungary, Vatican, Great Britain and Cyprus. The regulation applies only to people who are residents in the listed countries or Austrian citizens. It is also a prerequisite that you have not been in any country other than Austria or those European countries in the past 10 days. You can find the latest provisions here: <a href="https://www.sozialministerium.at">www.sozialministerium.at</a>',
#   # in this case the test info is equivalent to the quarantine info
#   status: 'WL'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Services',
#   name: 'tourism_accomodations',
#   description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter.<br><br><b><a href="https://tinyurl.com/y7x7mkny ">Rebook</a></b><br><br>Customers who had their domestic travel plans cancelled due to Coronavirus could be eligible for a reward when rebooking a stay at the same cancelled property via Booking.com. Rebookings must be made before 31/12/2020 and stays completed before 30/04/2021. The full amount paid goes directly to the accommodation provider. Please refer to terms and conditions as some exclusions apply. <br><br>Guarantee: No',
#   status: 'Y'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Services',
#   name: 'restaurants',
#   description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. All restaurants and catering facilities should close at 1 a.m..',
#   status: 'Y'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Services',
#   name: 'bars_cafes',
#   description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. All restaurants and catering facilities should close at 1 a.m..',
#   # same as restaurants
#   status: 'Y'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Services',
#   name: 'beaches',
#   description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter',
#   status: 'Y'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Services',
#   name: 'museums',
#   description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter.',
#   status: 'Y'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Services',
#   name: 'personal_services',
#   description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. If the minimum distance of one meter between customer and service provider cannot be maintained due to the nature of the service, this is only permitted if the risk of infection can be minimized by taking suitable protective measures.',
#   status: 'Y'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Services',
#   name: 'places_of_worship',
#   description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. A mask must be worn in most places of worship.',
#   status: 'Y'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Health & Safety',
#   name: 'high_risk_areas',
#   description: '',
#   status: 'N'
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Health & Safety',
#   name: 'masks_in_public',
#   description: 'Yes, a mask must be worn in certain areas: In grocery stores, public transport and taxis, during indoor events (except at the assigned seat), in cable cars, coaches and excursion boats, in gas stations, bank and post offices, in pharmacies, nursing homes and hospitals as well as in places where health and nursing services are provided and other services, if the 1 metre distance cannot be maintained or no other protective measures (e.g. plexiglass pane) are available. Special regulations apply to the federal states of Upper Austria and Carinthia.',
#   status: ''
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Health & Safety',
#   name: 'physical_distancing',
#   description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter',
#   status: ''
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Health & Safety',
#   name: 'health_protocols',
#   description: '<a href="https://www.sichere-gastfreundschaft.at">Sichere gastfreundschaft</a><br><a href="https://www.austria.info/en">Safe hospitality</a>',
#   status: ''
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Health & Safety',
#   name: 'public_transportation',
#   description: 'A mask must be worn in public transport and taxis.',
#   status: ''
#   )

# Indication.create!(
#   country: Country.first,
#   category: 'Health & Safety',
#   name: 'gatherings',
#   description: 'Events without assigned seats are allowed with a maximum of 100 visitors. Indoors events with assigned seats are allowed with a maximum of 250 visitors. Events with assigned seats in the open air are allowed with a maximum of 500 visitors.',
#   status: ''
#   )

puts 'Generating indications...'

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

puts "Indications created ;-)"

puts 'ALLLLLLL Done!'
