require "net/http"
require "json"

class SportsDbImporter
  LEAGUE_ID = "4373"
  API_BASE  = "https://www.thesportsdb.com/api/v1/json"

  def preview
    db_race = next_unfinished_race
    return { api_event: nil, db_race: nil, match: false, parsed_rows: [] } unless db_race

    summary   = fetch_past_events.last
    return { api_event: nil, db_race: db_race, match: false, parsed_rows: [] } unless summary

    api_event = fetch_event(summary["idEvent"])
    return { api_event: nil, db_race: db_race, match: false, parsed_rows: [] } unless api_event

    rows  = parse_result(api_event["strResult"])
    match = api_event["dateEvent"] == db_race.date.to_date.to_s

    { api_event: api_event, db_race: db_race, match: match, parsed_rows: rows }
  end

  def import!(race, parsed_rows)
    saved   = 0
    skipped = 0

    ActiveRecord::Base.transaction do
      parsed_rows.each do |row|
        driver = Driver.find_by(car_number: row[:car_number])
        unless driver
          skipped += 1
          next
        end

        result = race.race_results.find_or_initialize_by(driver: driver)
        result.finishing_position = row[:finishing_position]
        result.save!
        saved += 1
      end

      race.update!(status: :final)
    end

    [ saved, skipped ]
  end

  private

  def next_unfinished_race
    Race.where.not(status: :final).order(:date).first
  end

  def fetch_past_events
    uri = URI("#{API_BASE}/123/eventspastleague.php?id=#{LEAGUE_ID}")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.get(uri.request_uri) }
    data = JSON.parse(response.body)
    Array(data["events"])
  end

  def fetch_event(id)
    uri = URI("#{API_BASE}/123/lookupevent.php?id=#{id}")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.get(uri.request_uri) }
    data = JSON.parse(response.body)
    data["events"]&.first
  end

  def parse_result(str_result)
    str_result.strip.split("\r\n").filter_map do |row|
      cols = row.split("\t")
      next if cols.size < 3

      { finishing_position: cols[0].to_i, car_number: cols[2] }
    end
  end
end
