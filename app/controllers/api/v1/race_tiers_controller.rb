class Api::V1::RaceTiersController < Api::V1::BaseController
  def index
    race_tiers = RaceTier.where(race_id: params[:race_id])
                        .includes(drivers: :team)
                        .order(:tier_number)

    render json: race_tiers.map { |tier|
      {
        id: tier.id,
        tier_number: tier.tier_number,
        drivers: tier.drivers.map { |driver|
          {
            id: driver.id,
            name: driver.name,
            car_number: driver.car_number,
            team_name: driver.team&.name,
            primary_color: driver.primary_color,
            secondary_color: driver.secondary_color
          }
        }
      }
    }
  end
end
