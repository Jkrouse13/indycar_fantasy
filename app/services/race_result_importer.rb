class RaceResultImporter
  def import!(race, rows)
    saved   = 0
    skipped = 0

    ActiveRecord::Base.transaction do
      rows.each do |row|
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
end
