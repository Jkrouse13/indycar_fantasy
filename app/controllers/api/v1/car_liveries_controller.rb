class Api::V1::CarLiveriesController < Api::V1::BaseController
  def index
    race = Race.find(params[:race_id])
    liveries = race.race_car_liveries.includes(:driver).each_with_object({}) do |l, h|
      h[l.driver.car_number] = {
        image_url: l.image_url,
        primary_color: l.primary_color,
        secondary_color: l.secondary_color,
      }
    end
    render json: liveries
  end

  def parse
    url = params[:url]
    return render json: { error: "No URL provided" }, status: :unprocessable_entity if url.blank?

    rows = SpotterGuideParser.new.parse(url)
    render json: rows.map { |r|
      driver = Driver.find_by(car_number: r[:car_number])
      r.merge(
        driver_id: driver&.id,
        driver_name_matched: driver&.name,
        matched: driver.present?,
        primary_color: driver&.primary_color,
        secondary_color: driver&.secondary_color,
      )
    }
  end

  def confirm
    race = Race.find(params[:race_id])
    rows = params[:rows].map { |r| r.permit(:driver_id, :image_url, :primary_color, :secondary_color).to_h.symbolize_keys }
    count, skipped = CarLiveryImporter.new.import!(race, rows)
    render json: { success: true, updated: count, skipped: skipped, race_name: race.name }
  end

  def detect_colors
    rows = params[:rows].map { |r| r.permit(:driver_id, :car_number, :image_url, :endplate_url).to_h.symbolize_keys }
    detector = CarColorDetector.new

    results = rows.each_slice(CarColorDetector::BATCH_SIZE)
      .map { |batch| Thread.new { detector.detect_batch(batch) } }
      .flat_map(&:value)

    render json: results
  end
end
