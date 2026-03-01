# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding teams and drivers..."

# Teams
ganassi = Team.find_or_create_by!(name: "Chip Ganassi Racing")
penske = Team.find_or_create_by!(name: "Team Penske")
andretti = Team.find_or_create_by!(name: "Andretti Global")
arrow_mclaren = Team.find_or_create_by!(name: "Arrow McLaren")
rahal = Team.find_or_create_by!(name: "Rahal Letterman Lanigan Racing")
ecr = Team.find_or_create_by!(name: "Ed Carpenter Racing")
coyne = Team.find_or_create_by!(name: "Dale Coyne Racing")
foyt = Team.find_or_create_by!(name: "A.J. Foyt Enterprises")
juncos = Team.find_or_create_by!(name: "Juncos Hollinger Racing")
meyer_shank = Team.find_or_create_by!(name: "Meyer Shank Racing")

# Drivers
Driver.find_or_create_by!(car_number: 10) { |d| d.name = "Alex Palou"; d.team = ganassi }
Driver.find_or_create_by!(car_number: 9)  { |d| d.name = "Scott Dixon"; d.team = ganassi }
Driver.find_or_create_by!(car_number: 8)  { |d| d.name = "Kyffin Simpson"; d.team = ganassi }

Driver.find_or_create_by!(car_number: 2)  { |d| d.name = "Josef Newgarden"; d.team = penske }
Driver.find_or_create_by!(car_number: 3)  { |d| d.name = "Scott McLaughlin"; d.team = penske }
Driver.find_or_create_by!(car_number: 12) { |d| d.name = "David Malukas"; d.team = penske }

Driver.find_or_create_by!(car_number: 26) { |d| d.name = "Will Power"; d.team = andretti }
Driver.find_or_create_by!(car_number: 27) { |d| d.name = "Kyle Kirkwood"; d.team = andretti }
Driver.find_or_create_by!(car_number: 28) { |d| d.name = "Marcus Ericsson"; d.team = andretti }

Driver.find_or_create_by!(car_number: 5)  { |d| d.name = "Pato O'Ward"; d.team = arrow_mclaren }
Driver.find_or_create_by!(car_number: 7)  { |d| d.name = "Christian Lundgaard"; d.team = arrow_mclaren }
Driver.find_or_create_by!(car_number: 6)  { |d| d.name = "Nolan Siegel"; d.team = arrow_mclaren }

Driver.find_or_create_by!(car_number: 15) { |d| d.name = "Graham Rahal"; d.team = rahal }
Driver.find_or_create_by!(car_number: 47) { |d| d.name = "Mick Schumacher"; d.team = rahal }
Driver.find_or_create_by!(car_number: 45) { |d| d.name = "Louis Foster"; d.team = rahal }

Driver.find_or_create_by!(car_number: 20) { |d| d.name = "Alexander Rossi"; d.team = ecr }
Driver.find_or_create_by!(car_number: 21) { |d| d.name = "Christian Rasmussen"; d.team = ecr }

Driver.find_or_create_by!(car_number: 18) { |d| d.name = "Romain Grosjean"; d.team = coyne }
Driver.find_or_create_by!(car_number: 19) { |d| d.name = "Dennis Hauger"; d.team = coyne }

Driver.find_or_create_by!(car_number: 4)  { |d| d.name = "Caio Collet"; d.team = foyt }
Driver.find_or_create_by!(car_number: 14) { |d| d.name = "Santino Ferrucci"; d.team = foyt }

Driver.find_or_create_by!(car_number: 77) { |d| d.name = "Rinus VeeKay"; d.team = juncos }
Driver.find_or_create_by!(car_number: 75) { |d| d.name = "Sting Ray Robb"; d.team = juncos }

Driver.find_or_create_by!(car_number: 60) { |d| d.name = "Felix Rosenqvist"; d.team = meyer_shank }
Driver.find_or_create_by!(car_number: 66) { |d| d.name = "Marcus Armstrong"; d.team = meyer_shank }

puts "Seeding races..."

races = [
  { name: "Firestone Grand Prix of St. Petersburg", track: "Streets of St. Petersburg", date: "2026-03-01T17:00:00Z", green_flag_time: "2026-03-01T17:00:00Z", status: :final },
  { name: "Good Ranchers Phoenix Grand Prix", track: "Phoenix Raceway", date: "2026-03-07T20:00:00Z", green_flag_time: "2026-03-07T20:00:00Z", status: :upcoming },
  { name: "Java House Grand Prix of Arlington", track: "Streets of Arlington", date: "2026-03-15T17:30:00Z", green_flag_time: "2026-03-15T17:30:00Z", status: :upcoming },
  { name: "Grand Prix of Alabama", track: "Barber Motorsports Park", date: "2026-03-29T18:00:00Z", green_flag_time: "2026-03-29T18:00:00Z", status: :upcoming },
  { name: "Acura Grand Prix of Long Beach", track: "Streets of Long Beach", date: "2026-04-19T21:30:00Z", green_flag_time: "2026-04-19T21:30:00Z", status: :upcoming },
  { name: "Grand Prix of Indianapolis", track: "Indianapolis Motor Speedway Road Course", date: "2026-05-09T17:30:00Z", green_flag_time: "2026-05-09T17:30:00Z", status: :upcoming },
  { name: "Indianapolis 500", track: "Indianapolis Motor Speedway", date: "2026-05-24T17:45:00Z", green_flag_time: "2026-05-24T17:45:00Z", status: :upcoming },
  { name: "Chevrolet Detroit Grand Prix", track: "Streets of Detroit", date: "2026-05-31T20:30:00Z", green_flag_time: "2026-05-31T20:30:00Z", status: :upcoming },
  { name: "Enjoy Illinois 300", track: "World Wide Technology Raceway", date: "2026-06-06T23:00:00Z", green_flag_time: "2026-06-06T23:00:00Z", status: :upcoming },
  { name: "XPEL Grand Prix", track: "Road America", date: "2026-06-21T19:00:00Z", green_flag_time: "2026-06-21T19:00:00Z", status: :upcoming },
  { name: "Honda Indy 200 at Mid-Ohio", track: "Mid-Ohio Sports Car Course", date: "2026-07-05T19:30:00Z", green_flag_time: "2026-07-05T19:30:00Z", status: :upcoming },
  { name: "Music City Grand Prix", track: "Nashville Superspeedway", date: "2026-07-19T23:00:00Z", green_flag_time: "2026-07-19T23:00:00Z", status: :upcoming },
  { name: "Milwaukee Mile Race 1", track: "Milwaukee Mile", date: "2026-08-08T20:00:00Z", green_flag_time: "2026-08-08T20:00:00Z", status: :upcoming },
  { name: "Milwaukee Mile Race 2", track: "Milwaukee Mile", date: "2026-08-09T20:00:00Z", green_flag_time: "2026-08-09T20:00:00Z", status: :upcoming },
  { name: "Freedom 250", track: "Streets of Washington D.C.", date: "2026-08-23T22:00:00Z", green_flag_time: "2026-08-23T22:00:00Z", status: :upcoming },
  { name: "Grand Prix of Markham", track: "Streets of Markham", date: "2026-08-16T19:00:00Z", green_flag_time: "2026-08-16T19:00:00Z", status: :upcoming },
  { name: "Bommarito Automotive Group 500", track: "World Wide Technology Raceway", date: "2026-08-29T23:00:00Z", green_flag_time: "2026-08-29T23:00:00Z", status: :upcoming },
  { name: "Firestone Grand Prix of Monterey", track: "WeatherTech Raceway Laguna Seca", date: "2026-09-06T21:00:00Z", green_flag_time: "2026-09-06T21:00:00Z", status: :upcoming }
]

races.each do |race_data|
  Race.find_or_create_by!(name: race_data[:name]) do |r|
    r.track = race_data[:track]
    r.date = race_data[:date]
    r.green_flag_time = race_data[:green_flag_time]
    r.status = race_data[:status]
    r.season_year = 2026
  end
end

puts "Done! #{Team.count} teams, #{Driver.count} drivers, #{Race.count} races seeded."
