# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'pry-byebug'
require 'date'
require 'open-uri'
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
kleyv = User.create!(
  first_name: 'Eukleyv',
  last_name: 'Smith',
  phone_number: '123456789',
  email: 'eukleyv@gmail.com',
  password: '123456',
  country_id: Country.all.sample.id
  )
file = URI.open('https://kitt.lewagon.com/placeholder/users/kleyv')
kleyv.photo.attach(io: file, filename: 'kleyv_avatar.png', content_type: 'image/png')

florian = User.create!(
  first_name: 'Florian',
  last_name: 'Smith',
  phone_number: '123456789',
  email: 'florian@gmail.com',
  password: '123456',
  country_id: Country.all.sample.id
  )
file = URI.open('https://kitt.lewagon.com/placeholder/users/Flott2014')
florian.photo.attach(io: file, filename: 'florian_avatar.png', content_type: 'image/png')

raffaelle = User.create!(
  first_name: 'Raffaelle',
  last_name: 'Smith',
  phone_number: '123456789',
  email: 'raffaelle@gmail.com',
  password: '123456',
  country_id: Country.all.sample.id
  )
file = URI.open('https://kitt.lewagon.com/placeholder/users/raffoz')
raffaelle.photo.attach(io: file, filename: 'raffaelle_avatar.png', content_type: 'image/png')

tiago = User.create!(
  first_name: 'Tiago',
  last_name: 'Smith',
  phone_number: '123456789',
  email: 'tiago@gmail.com',
  password: '123456',
  country_id: Country.all.sample.id
  )
file = URI.open('https://kitt.lewagon.com/placeholder/users/Tiago-Palhoca')
tiago.photo.attach(io: file, filename: 'tiago_avatar.png', content_type: 'image/png')


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
  description: 'Entering from a country with a stable COVID-19 situation&nbsp;is possible without restrictions.</p><p>Currently, travelling to and from EU countries is allowed without restrictions, with the exception of <strong>Portugal</strong>, <strong>Sweden</strong>, <strong>Bulgaria</strong> and <strong>Romania</strong>.<br />Travelling to and from Norway, Switzerland, Iceland and Liechtenstein, as well as Andorra, Monaco, Vatican City State and the Republic of San Marino, is allowed without restrictions.</p><p>When&nbsp;entering from a country in which there is no stable COVID-19 situation,&nbsp;entry is possible with a health certificate&nbsp;(<a href="https://www.sozialministerium.at/dam/jcr:34b1ed5c-5135-473c-b41a-85f42bd673be/336.%20Verordnung%20-%20Anlage%20C.pdf">Annex C</a>).&nbsp;<br /><br /><strong>Rules and Exceptions</strong><br />The prerequisite&nbsp;to enter Austria is that the traveller has&nbsp;only resided in countries with a stable COVID-19 situation in the past ten days&nbsp;and is resident or habitually resident in Austria or in one of these countries.</p><p>Entry from a country with a stable COVID-19 situation is possible without restrictions. The corresponding countries are listed in <a href="https://www.sozialministerium.at/dam/jcr:17bc058c-811f-48e7-95d0-56eb43f1bad4/336.%20Verordnung%20-%20Anlage%20A1.pdf">Appendix A1</a> of the Entry Ordinance and are currently (as of 27.07.2020): Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Croatia, Latvia, Liechtenstein, Lithuania, Luxembourg, Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain, Czech Republic, Hungary, Vatican, United Kingdom and Cyprus.<br />If the person has also been in other countries within the last 10 days, entry is possible either with a medical certificate confirming a negative PCR test (performed within 72 hours prior to entry) or by undergoing a 10-day (home) quarantine. A confirmation of accommodation must be presented and any costs incurred must be paid for by yourself. Quarantine can be terminated if a PCR test performed during the period is negative.</p><p><strong>Children up to the age of 6</strong>&nbsp;are exempt from compulsory testing upon entry.</p><p><strong>Mandatory Travel Documentation</strong><br />No<br /><br /><strong>Specific measures for Austrian citizens returning to Austria</strong></p><p>Country specific travel information are available at&nbsp;<a href="https://www.bmeia.gv.at/reise-aufenthalt/reiseinformation/laender/">www.bmeia.gv.at</a></p><p>Entry from a country with a stable COVID-19 situation is possible without restrictions. The corresponding countries are listed in <a href="https://www.sozialministerium.at/dam/jcr:17bc058c-811f-48e7-95d0-56eb43f1bad4/336.%20Verordnung%20-%20Anlage%20A1.pdf">Appendix A1</a> of the Entry Ordinance and are currently (as of 27.07.2020): Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Croatia, Latvia, Liechtenstein, Lithuania, Luxembourg, Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain, Czech Republic, Hungary, Vatican, United Kingdom and Cyprus.<br />If the person has also been in other countries within the last 10 days, entry is possible either with a medical certificate confirming a negative PCR test (performed within 72 hours prior to entry) or by undergoing a 10-day (home) quarantine. A confirmation of accommodation must be presented and any costs incurred must be paid for by yourself. Quarantine can be terminated if a PCR test performed during the period is negative.</p><p><strong>Children up to the age of 6</strong>&nbsp;are exempt from compulsory testing upon entry.<br /><br /><strong>Links to relevant national sources</strong><br /><a href="https://www.sozialministerium.at/Informationen-zum-Coronavirus/Coronavirus---Haeufig-gestellte-Fragen/FAQ--Reisen-und-Tourismus.html">FAQs on travel and tourism (www.sozialministerium.at)</a><br /><a href="https://www.bmeia.gv.at/reise-aufenthalt/reiseinformation/laender/">www.bmeia.gv.at</a></p><p>&nbsp;',
  status: 'WL'
  )

Indication.create!(
  country: Country.first,
  category: 'Travel',
  name: 'quarantine',
  description: 'Travellers from the following countries can enter or leave Austria without restrictions: Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Croatia, Latvia, Liechtenstein, Lithuania, Luxembourg , Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain, Czech Republic, Hungary, Vatican, Great Britain and Cyprus. The regulation applies only to people who are residents in the listed countries or Austrian citizens. It is also a prerequisite that you have not been in any country other than Austria or those European countries in the past 10 days. You can find the latest provisions here: <a href="https://www.sozialministerium.at">www.sozialministerium.at</a>',
  status: 'WL'
  )

Indication.create!(
  country: Country.first,
  category: 'Travel',
  name: 'test',
  description: 'Travellers from the following countries can enter or leave Austria without restrictions: Andorra, Belgium, Denmark, Germany, Estonia, Finland, France, Greece, Ireland, Iceland, Italy, Croatia, Latvia, Liechtenstein, Lithuania, Luxembourg , Malta, Monaco, Netherlands, Norway, Poland, San Marino, Switzerland, Slovakia, Slovenia, Spain, Czech Republic, Hungary, Vatican, Great Britain and Cyprus. The regulation applies only to people who are residents in the listed countries or Austrian citizens. It is also a prerequisite that you have not been in any country other than Austria or those European countries in the past 10 days. You can find the latest provisions here: <a href="https://www.sozialministerium.at">www.sozialministerium.at</a>',
  # in this case the test info is equivalent to the quarantine info
  status: 'WL'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'tourism_accomodations',
  description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter.<br><br><b><a href="https://tinyurl.com/y7x7mkny ">Rebook</a></b><br><br>Customers who had their domestic travel plans cancelled due to Coronavirus could be eligible for a reward when rebooking a stay at the same cancelled property via Booking.com. Rebookings must be made before 31/12/2020 and stays completed before 30/04/2021. The full amount paid goes directly to the accommodation provider. Please refer to terms and conditions as some exclusions apply. <br><br>Guarantee: No',
  status: 'Y'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'restaurants',
  description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. All restaurants and catering facilities should close at 1 a.m..',
  status: 'Y'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'bars_cafes',
  description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. All restaurants and catering facilities should close at 1 a.m..',
  # same as restaurants
  status: 'Y'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'beaches',
  description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter',
  status: 'Y'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'museums',
  description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter.',
  status: 'Y'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'personal_services',
  description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. If the minimum distance of one meter between customer and service provider cannot be maintained due to the nature of the service, this is only permitted if the risk of infection can be minimized by taking suitable protective measures.',
  status: 'Y'
  )

Indication.create!(
  country: Country.first,
  category: 'Services',
  name: 'places_of_worship',
  description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter. A mask must be worn in most places of worship.',
  status: 'Y'
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'high_risk_areas',
  description: '',
  status: 'N'
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'masks_in_public',
  description: 'Yes, a mask must be worn in certain areas: In grocery stores, public transport and taxis, during indoor events (except at the assigned seat), in cable cars, coaches and excursion boats, in gas stations, bank and post offices, in pharmacies, nursing homes and hospitals as well as in places where health and nursing services are provided and other services, if the 1 metre distance cannot be maintained or no other protective measures (e.g. plexiglass pane) are available. Special regulations apply to the federal states of Upper Austria and Carinthia.',
  status: ''
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'physical_distancing',
  description: 'Yes. When entering public places, people who do not live in the same household must be kept at a distance of at least one meter',
  status: ''
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'health_protocols',
  description: '<a href="https://www.sichere-gastfreundschaft.at">Sichere gastfreundschaft</a><br><a href="https://www.austria.info/en">Safe hospitality</a>',
  status: ''
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'public_transportation',
  description: 'A mask must be worn in public transport and taxis.',
  status: ''
  )

Indication.create!(
  country: Country.first,
  category: 'Health & Safety',
  name: 'gatherings',
  description: 'Events without assigned seats are allowed with a maximum of 100 visitors. Indoors events with assigned seats are allowed with a maximum of 250 visitors. Events with assigned seats in the open air are allowed with a maximum of 500 visitors.',
  status: ''
  )

puts 'Done!'
