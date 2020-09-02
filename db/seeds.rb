# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'pry-byebug'
require 'date'
# consider refactoring and separate seeds into separate files
# require_relative './_indications'


Country.destroy_all
# Order of creation of seed: 1. countries, 2. cases, 3. indications, 4. users, 5. trips

# Countries
# Don't forget to add flags
# Constant with all countries
countries = ["Austria", "Croatia", "France", "Germany", "Greece", "Italy", "Portugal", "Spain", "United Kingdom"]

# For loop that creates a country instance using the strings in the countries constant
puts 'Generating countries...'
for country in countries
  Country.create!(name: country)
end

# Cases
# Seed for the starting point on the first day

current_day = Date.today
day_zero = Date.new(2020, 8, 1)
days_since_day_zero = (current_day - day_zero).to_i


puts 'Generating cases...'
Country.all.each do |country|
  Case.create!(
    date: day_zero.strftime('%Y-%m-%d'),
    country_id: country.id, # random from the length of countries
    total_cases: 0,
    new_cases: 0,
    total_deaths: 0,
    new_deaths: 0,
    population: rand(1_000_000..1_000_000_000),
    total_tests: 0,
    new_tests: 0,
    tests_per_case: 0.0, # float
    stringency_index: 0 # from 0 to 100. 100 being the strictest
    )
end


# The following seed will take the values from the seed above and update them
# Create seeds from all days since 2020-01-01
day = 1
days_since_day_zero.times do


  # Create new data starting from the previous seed with new daily value
  Country.all.each do |country|
    previous_case = Case.where(country_id: country.id).last
    Case.create!(
      date: (day_zero + day).strftime('%Y-%m-%d'),
      country_id: country.id, # random from the length of countries
      total_cases: previous_case.total_cases + rand(0..100),
      new_cases: previous_case.new_cases + rand(0..100),
      total_deaths: previous_case.total_deaths + rand(0..100),
      new_deaths: previous_case.new_deaths + rand(0..50),
      population: previous_case.population,
      total_tests: previous_case.total_tests + rand(0..1000),
      new_tests: previous_case.new_tests + rand(0..1000),
      tests_per_case: previous_case.tests_per_case + rand(0.0..1000.0),
      stringency_index: rand(0..100)
      )
  end
  day += 1 # go to the next day.
end


# Users
# Don't forget to add images

# Create 4 static users that we can always count on for tests

puts 'Generating users...'
User.create!(
  first_name: 'Eukleyv',
  last_name: 'Smith',
  phone_number: '123456789',
  email: 'eukleyv@gmail.com',
  password: '123456',
  country_id: Country.all.sample.id
  )
User.create!(
  first_name: 'Florian',
  last_name: 'Smith',
  phone_number: '123456789',
  email: 'florian@gmail.com',
  password: '123456',
  country_id: Country.all.sample.id
  )
User.create!(
  first_name: 'Raffaelle',
  last_name: 'Smith',
  phone_number: '123456789',
  email: 'raffaelle@gmail.com',
  password: '123456',
  country_id: Country.all.sample.id
  )
User.create!(
  first_name: 'Tiago',
  last_name: 'Smith',
  phone_number: '123456789',
  email: 'tiago@gmail.com',
  password: '123456',
  country_id: Country.all.sample.id
  )


# Trips

puts 'Generating trips...'
# A for loop to create all possible trips
for country_a in countries
  # create countries_prime that contains all countries except the origin country so the origin isn't equal to the destination
  countries_prime = countries.reject{ |country|
      country == country_a
    }
  for country_b in countries_prime
    Trip.create!(
      origin: Country.find_by(name: country_a), # get origin from coutries array
      destination: Country.find_by(name: country_b), # get destination from countries_prime array
      user: User.all.sample,
      bookmarked: [true, false].sample
      )
  end
end


# Indication
# It's imported from another file to avoid making this file too big

puts 'Generating trips...'

Indication.create!(
  country: Country.first,
  category: 'Travel',
  name: 'open',
  description: 'May I fly to this country?',
  status: 'Travelling to Austria
  Entry from a country with a stable COVID-19 situation is possible without restrictions. The corresponding countries are listed in Appendix A1 of the Entry Ordinance and are currently: Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Latvia, Liechtenstein, Lithuania, Luxembourg, Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain (only the Canary Islands), Czech Republic, Hungary, Vatican, United Kingdom and Cyprus.
  Travelling from Austria or returning to Austria
  Travel Information from the Ministry of Foreign Affairs can be found at www.bmeia.gv.at
  Rules and Exceptions
  The prerequisite to enter Austria is that the traveller has only resided in countries with a stable COVID-19 situation in the past ten days and is resident or habitually resident in Austria or in one of these countries.'
  )

Indication.create!(
  country: Country.first,
  category: 'Travel',
  name: 'quarantine',
  description: 'May I enter this country without being subject to a mandatory quarantine?',
  status: 'Travellers from the following countries can enter or leave Austria without restrictions: Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Latvia, Liechtenstein, Lithuania, Luxembourg , Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain (only Canary Islands), Czech Republic, Hungary, Vatican and Cyprus. The regulation applies only to people who are residents in the listed countries or Austrian citizens. It is also a prerequisite that you have not been in any country other than Austria or those European countries in the past 10 days. You can find the latest provisions here: www.sozialministerium.at'
  )

Indication.create!(
  country: Country.first,
  category: 'Travel',
  name: 'test',
  description: 'May I enter this country without a medical certificate or a negative test?',
  # in this case the test info is equivalent to the quarantine info
  status: 'Travellers from the following countries can enter or leave Austria without restrictions: Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Latvia, Liechtenstein, Lithuania, Luxembourg , Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain (only Canary Islands), Czech Republic, Hungary, Vatican and Cyprus. The regulation applies only to people who are residents in the listed countries or Austrian citizens. It is also a prerequisite that you have not been in any country other than Austria or those European countries in the past 10 days. You can find the latest provisions here: www.sozialministerium.at'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'tourism_accomodations',
  description: 'Are tourism accommodations open?',
  status: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter.'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'restaurants',
  description: 'Are restaurants open?',
  status: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. All restaurants and catering facilities should close at 1 a.m..'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'bars_cafes',
  description: 'Are bars & cafés open?',
  # same as restaurants
  status: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. All restaurants and catering facilities should close at 1 a.m..'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'beaches',
  description: 'Are beaches and tourist areas openly accessible?',
  status: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter.'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'museums',
  description: 'Are museums & heritage sites open?',
  status: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter.'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'personal_services',
  description: 'Are personal care services available?',
  status: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. If the minimum distance of one meter between customer and service provider cannot be maintained due to the nature of the service, this is only permitted if the risk of infection can be minimized by taking suitable protective measures.'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'places_of_worship',
  description: 'Are places of worship accessible?',
  status: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. A mask must be worn in most places of worship.'
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'high_risk_areas',
  description: 'Are there any risk areas under lockdown in this country?',
  status: 'No'
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'masks_in_public',
  description: 'Is a mask required in public?',
  status: 'Yes, a mask must be worn in certain areas: In grocery stores, public transport and taxis, during indoor events (except at the assigned seat), in cable cars, coaches and excursion boats, in gas stations, bank and post offices, in pharmacies, nursing homes and hospitals as well as in places where health and nursing services are provided and other services, if the 1 metre distance cannot be maintained or no other protective measures (e.g. plexiglass pane) are available. Special regulations apply to the federal states of Upper Austria and Carinthia.'
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'physical_distancing',
  description: 'Is physical distancing required?',
  status: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter.'
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'health_protocols',
  description: 'IHealth protocols for tourism services and tourists',
  status: '<a href="https://www.sichere-gastfreundschaft.at">Sichere gastfreundschaft</a><br><a href="https://www.austria.info/en">Safe hospitality</a>'
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'gatherings',
  description: 'Gatherings',
  status: 'Events without assigned seats are allowed with a maximum of 200 visitors. Indoors events with assigned seats are allowed with a maximum of 500 visitors. Events with assigned seats in the open air are allowed with a maximum of 750 visitors. In addition, there is the possibility of holding events with assigned and marked seats in a higher number of participants by means of a permit from the district administrative authority with up to 1,000 people in closed rooms and with up to 1,250 people in the open air.'
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'public_transportation',
  description: 'Safety measures for public transportation',
  status: 'A mask must be worn in public transport and taxis and in case of large crowds. '
  )
puts 'Done!'
