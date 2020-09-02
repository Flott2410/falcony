# CSV Parsing
require 'csv'
require 'date'

require 'byebug'

# this is for the "press a key to continue" function
require 'io/console'

# Define a variable
@country = "ITA"

# CSF filepath
filepath = 'archive.csv'

# must use liberal_parsing to go through it
# https://stackoverflow.com/a/48116207/12598093
csv_options = { col_sep: ';', headers: :first_row, liberal_parsing: true }

# CSV.foreach(filepath, csv_options).with_index do |row, index|
#   # row comes out as an array: here, row is an array of columns
#   puts "Line: #{index + 2}"
#   puts "Last Update: #{row[0]}"               # LastUpdate
#   puts "Country: #{row[1]}"                   # Country
#   puts "Category: #{row[2]}"                  # Category
#   puts "Indicator text: #{row[3]}"            # Indicator text
#   puts "Cod.Category: #{row[4]}"              # Cod.Category
#   puts "Cod. Indicator: #{row[5]}"            # Cod.Indicator
#   puts "Value: #{row[6]}"                     # value
#   puts "Comment: #{row[7]}\n"                 # comment
#   # "#{row[0]} | #{row[1]} | #{row[2]}"
# end

# Store the CSV in a file
@csv_file = CSV.read(filepath, csv_options)

# Change all dates from String.class to Date.class
# Date.strptime(d, '%d-%m-%y')
# https://ruby-doc.org/stdlib-2.4.1/libdoc/date/rdoc/Date.html#method-c-parse
@csv_file.each do |row|
  row[0] = Date.strptime(row[0], '%d-%m-%y')
end

# Find a specified line inside an array of arrays (CSV Row)
# https://stackoverflow.com/questions/30188688/ruby-array-of-arrays-find-by-inner-array-value
# example = csv_file.select { |element| element[1] == 'AUT' && element[2] == 'Travel' && element[3] == "May I freely move within this country?" }
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

# def group_size_public(country)
#   select_row(4, 8, country)
# end
# it's the same of gatherings

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

def continue_story
  print "press any key"
  STDIN.getch
end

def print_test(name_of_indication)
  row = name_of_indication
  system('clear')
  puts "Country: #{row[1]}"
  puts
  puts "#{row[2]}: #{row[3]}"
  puts "Answer: #{row[7]}"
  puts
  puts "Last update: #{row[0].strftime('%d %b %Y')}"
  puts
end

# Try to print one choosen method
puts print_test(open('ITA'))
continue_story
puts print_test(quarantine('AUT'))
continue_story
puts print_test(museums('DEU'))
continue_story
