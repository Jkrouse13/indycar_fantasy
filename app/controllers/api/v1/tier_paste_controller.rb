class Api::V1::TierPasteController < Api::V1::BaseController
  def parse
    rows = TierPasteParser.new.parse(params[:text])
    render json: rows
  end

  def confirm
    race = Race.find(params[:race_id])
    tiers_params = params.require(:tiers).to_unsafe_h

    tiers_params.each do |tier_number, driver_ids|
      tier = RaceTier.find_or_create_by!(race: race, tier_number: tier_number.to_i)
      tier.driver_ids = Array(driver_ids)
    end

    render json: { success: true, race_name: race.name }
  end
end
