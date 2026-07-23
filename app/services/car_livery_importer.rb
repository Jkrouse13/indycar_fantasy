class CarLiveryImporter
  def import!(race, rows)
    saved = 0
    skipped = 0

    ActiveRecord::Base.transaction do
      rows.each do |row|
        driver = Driver.find_by(id: row[:driver_id])
        unless driver
          skipped += 1
          next
        end

        livery = race.race_car_liveries.find_or_initialize_by(driver: driver)
        livery.image_url = row[:image_url]
        livery.primary_color = row[:primary_color] if row[:primary_color].present?
        livery.secondary_color = row[:secondary_color] if row[:secondary_color].present?
        livery.primary_color ||= driver.primary_color
        livery.secondary_color ||= driver.secondary_color
        livery.save!
        saved += 1
      end
    end

    [ saved, skipped ]
  end
end
