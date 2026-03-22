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

Driver.find_or_create_by!(car_number: 76) { |d| d.name = "Rinus VeeKay"; d.team = juncos }
Driver.find_or_create_by!(car_number: 77) { |d| d.name = "Sting Ray Robb"; d.team = juncos }

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

puts "Seeding St. Petersburg race results..."


st_pete = Race.find_by(name: "Firestone Grand Prix of St. Petersburg")
st_pete.update!(status: :final)

st_pete_results = [
  { car: 10, pos: 1  },  # Palou
  { car: 3,  pos: 2  },  # McLaughlin
  { car: 7,  pos: 3  },  # Lundgaard
  { car: 27, pos: 4  },  # Kirkwood
  { car: 5,  pos: 5  },  # O'Ward
  { car: 28, pos: 6  },  # Ericsson
  { car: 2,  pos: 7  },  # Newgarden
  { car: 18, pos: 8  },  # Grosjean
  { car: 76, pos: 9  },  # VeeKay
  { car: 19, pos: 10 },  # Hauger
  { car: 66, pos: 11 },  # Armstrong
  { car: 60, pos: 12 },  # Rosenqvist
  { car: 12, pos: 13 },  # Malukas
  { car: 45, pos: 14 },  # Foster
  { car: 8,  pos: 15 },  # Simpson
  { car: 20, pos: 16 },  # Rossi
  { car: 4,  pos: 17 },  # Collet
  { car: 15, pos: 18 },  # Rahal
  { car: 21, pos: 19 },  # Rasmussen
  { car: 6,  pos: 20 },  # Siegel
  { car: 77, pos: 21 },  # Robb
  { car: 26, pos: 22 },  # Power (Retired)
  { car: 9,  pos: 23 },  # Dixon (Off Course)
  { car: 14, pos: 24 },  # Ferrucci (Contact)
  { car: 47, pos: 25 }  # Schumacher (Contact)
]

st_pete_results.each do |r|
  driver = Driver.find_by(car_number: r[:car])
  RaceResult.find_or_create_by!(race: st_pete, driver: driver) do |result|
    result.finishing_position = r[:pos]
  end
end

puts "Done! St. Petersburg results seeded."

puts "Seeding St. Petersburg tiers..."

st_pete = Race.find_by(name: "Firestone Grand Prix of St. Petersburg")

tiers = {
  1 => [ "Alex Palou", "Pato O'Ward", "Scott McLaughlin", "David Malukas" ],
  2 => [ "Felix Rosenqvist", "Marcus Ericsson", "Marcus Armstrong", "Christian Lundgaard" ],
  3 => [ "Josef Newgarden", "Kyle Kirkwood", "Will Power", "Romain Grosjean", "Louis Foster", "Scott Dixon" ],
  4 => [ "Rinus VeeKay", "Kyffin Simpson", "Alexander Rossi", "Christian Rasmussen", "Dennis Hauger" ],
  5 => [ "Nolan Siegel", "Santino Ferrucci", "Graham Rahal" ],
  6 => [ "Mick Schumacher", "Caio Collet", "Sting Ray Robb" ]
}

tiers.each do |tier_number, driver_names|
  tier = RaceTier.find_or_create_by!(race: st_pete, tier_number: tier_number)
  driver_names.each do |name|
    driver = Driver.find_by(name: name)
    if driver
      TierDriver.find_or_create_by!(race_tier: tier, driver: driver)
    else
      puts "WARNING: Driver not found: #{name}"
    end
  end
end

puts "Done! St. Petersburg tiers seeded."

puts "Seeding St. Pete participants and picks..."

st_pete = Race.find_by(name: "Firestone Grand Prix of St. Petersburg")

participants_data = [
  { name: "Theo",      email: "theo@krouse.com" },
  { name: "Lilly",     email: "lilly@krouse.com" },
  { name: "Pete",      email: "pete@krouse.com" },
  { name: "Sarah",     email: "sarahszybowski@gmail.com" },
  { name: "Ellie",     email: "ellie@szybowski.com" },
  { name: "Eli",       email: "eli@szybowski.com" },
  { name: "Katie",     email: "kathleen.c.krouse@gmail.com" },
  { name: "Jacob",     email: "jacob.krouse@gmail.com" },
  { name: "Uncle Jon", email: "jon.krouse@hey.com" }
]

picks_data = [
  { email: "theo@krouse.com",             1 => "Pato",       2 => "Lundgaard", 3 => "Dixon",  4 => "Hauger",  5 => "Rahal",    6 => "Robb" },
  { email: "lilly@krouse.com",            1 => "Palou",      2 => "Ericsson",  3 => "Dixon",  4 => "Hauger",  5 => "Rahal",    6 => "Robb" },
  { email: "pete@krouse.com",             1 => "Palou",      2 => "Ericsson",  3 => "Dixon",  4 => "VeeKay",  5 => "Ferrucci", 6 => "Robb" },
  { email: "sarahszybowski@gmail.com",    1 => "Pato",       2 => "Lundgaard", 3 => "Dixon",  4 => "Hauger",  5 => "Rahal",    6 => "Robb" },
  { email: "ellie@szybowski.com",         1 => "Pato",       2 => "Lundgaard", 3 => "Dixon",  4 => "Hauger",  5 => "Rahal",    6 => "Robb" },
  { email: "eli@szybowski.com",           1 => "Palou",      2 => "Lundgaard", 3 => "Dixon",  4 => "Rossi",   5 => "Rahal",    6 => "Robb" },
  { email: "kathleen.c.krouse@gmail.com", 1 => "McLaughlin", 2 => "Rosenqvist", 3 => "Foster", 4 => "Simpson", 5 => "Ferrucci", 6 => "Schumacher" },
  { email: "jacob.krouse@gmail.com",      1 => "McLaughlin", 2 => "Ericsson",  3 => "Foster", 4 => "Simpson", 5 => "Rahal",    6 => "Schumacher" },
  { email: "jon.krouse@hey.com",          1 => "Palou",      2 => "Ericsson",  3 => "Kirkwood", 4 => "Hauger", 5 => "Rahal",    6 => "Schumacher" }
]

picks_data.each do |data|
  email = data[:email]
  person = participants_data.find { |p| p[:email] == email }

  participant = Participant.find_or_create_by!(email: email.downcase) do |p|
    p.name = person[:name]
  end

  (1..6).each do |tier_number|
    identifier = data[tier_number]
    driver = Driver.find_by("name ILIKE ?", "%#{identifier}%")
    race_tier = RaceTier.find_by(race: st_pete, tier_number: tier_number)

    if driver && race_tier
      Pick.find_or_create_by!(
        participant: participant,
        race: st_pete,
        race_tier: race_tier
      ) do |pick|
        pick.driver = driver
      end
    else
      puts "WARNING: Could not find driver '#{identifier}' for #{email} tier #{tier_number}"
    end
  end
end

puts "Done! #{Participant.count} participants, #{Pick.count} picks seeded."

puts "Seeding driver car colors..."

car_colors = {
  2  => { primary: "#C8102E", secondary: "#C0C0C0" },  # Newgarden - red/silver
  3  => { primary: "#C8102E", secondary: "#FFFFFF" },  # McLaughlin - red/white
  4  => { primary: "#00843D", secondary: "#FFD100" },  # Collet - green/yellow
  5  => { primary: "#FF6900", secondary: "#000000" },  # O'Ward - orange/black
  6  => { primary: "#FF6900", secondary: "#003087" },  # Siegel - orange/blue
  7  => { primary: "#FF6900", secondary: "#000000" },  # Lundgaard - orange/black
  8  => { primary: "#003087", secondary: "#FFD100" },  # Simpson - blue/yellow
  9  => { primary: "#003087", secondary: "#FF6900" },  # Dixon - blue/orange
  10 => { primary: "#FFD100", secondary: "#C8102E" },  # Palou - yellow/red
  12 => { primary: "#C8102E", secondary: "#FFFFFF" },  # Malukas - red/white
  14 => { primary: "#003087", secondary: "#FFFFFF" },  # Ferrucci - blue/white
  15 => { primary: "#00843D", secondary: "#FFFFFF" },  # Rahal - green/white
  18 => { primary: "#000000", secondary: "#FF6900" },  # Grosjean - black/orange
  19 => { primary: "#000000", secondary: "#C8102E" },  # Hauger - black/red
  20 => { primary: "#00843D", secondary: "#FFFFFF" },  # Rossi - green/white
  21 => { primary: "#FFFFFF", secondary: "#00843D" },  # Rasmussen - white/green
  26 => { primary: "#000000", secondary: "#FFD100" },  # Power - black/yellow
  27 => { primary: "#FFFFFF", secondary: "#003087" },  # Kirkwood - white/blue
  28 => { primary: "#008080", secondary: "#FFFFFF" },  # Ericsson - teal/white
  45 => { primary: "#FFFFFF", secondary: "#003087" },  # Foster - white/blue
  47 => { primary: "#000000", secondary: "#C8102E" },  # Schumacher - black/red
  60 => { primary: "#000000", secondary: "#C8102E" },  # Rosenqvist - black/red
  66 => { primary: "#FF6900", secondary: "#000000" },  # Armstrong - orange/black
  76 => { primary: "#FFFFFF", secondary: "#003087" },  # VeeKay - white/blue
  77 => { primary: "#C8102E", secondary: "#FFFFFF" }  # Robb - red/white
}

# car_colors.each do |car_number, colors|
#   driver = Driver.find_by(car_number: car_number)
#   if driver
#     driver.update!(primary_color: colors[:primary], secondary_color: colors[:secondary])
#   else
#     puts "WARNING: Driver with car ##{car_number} not found"
#   end
# end

puts "Done! Driver colors seeded."
