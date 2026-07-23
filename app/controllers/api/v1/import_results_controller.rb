class Api::V1::ImportResultsController < Api::V1::BaseController
  def parse
    file = params[:pdf_file]
    return render json: { error: "No file provided" }, status: :unprocessable_entity unless file

    rows = IndycarPdfParser.new.parse(file.tempfile)
    render json: rows.map { |r|
      driver = Driver.find_by(car_number: r[:car_number])
      r.merge(driver_name_matched: driver&.name, matched: driver.present?)
    }
  end

  def confirm
    race = Race.find(params[:race_id])
    rows = params[:rows].map { |r| r.permit(:finishing_position, :car_number, :driver_name).to_h.symbolize_keys }
    count, skipped = RaceResultImporter.new.import!(race, rows)
    render json: { success: true, imported: count, skipped: skipped, race_name: race.name }
  end
end
