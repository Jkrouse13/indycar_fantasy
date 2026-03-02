class Api::V1::RaceTiersController < Api::V1::BaseController
  def index
    race_tiers = RaceTier.includes(tier_drivers: :driver)
                         .where(race_id: params[:race_id])
                         .order(:tier_number)
    render json: race_tiers.map { |tier|
      {
        id: tier.id,
        tier_number: tier.tier_number,
        drivers: tier.drivers.map { |d| {
          id: d.id,
          name: d.name,
          car_number: d.car_number,
          primary_color: d.primary_color,
          secondary_color: d.secondary_color
        } }
      }
    }
  end
end
