# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'pry-byebug'
require 'date'

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
# TODO
puts 'Done!'
