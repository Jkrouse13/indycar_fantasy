class Api::V1::RaceTiersController < Api::V1::BaseController
  def index
    race_tiers = RaceTier.where(race_id: params[:race_id])
                        .includes(drivers: :team)
                        .order(:tier_number)

    render json: race_tiers.map { |tier|
      {
        id: tier.id,
        tier_number: tier.tier_number,
        drivers: tier.drivers.sort_by { |d| d.car_number.to_i }.map { |driver|
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

  def create
    race = Race.find(params[:race_id])
    tier = race.race_tiers.build(tier_number: params.dig(:race_tier, :tier_number))
    tier.driver_ids = Array(params.dig(:race_tier, :driver_ids))
    tier.save!
    render json: { id: tier.id, tier_number: tier.tier_number }, status: :created
  end

  def update
    tier = RaceTier.find(params[:id])
    tier.driver_ids = Array(params.dig(:race_tier, :driver_ids))
    render json: { id: tier.id }, status: :ok
  end

  def destroy
    RaceTier.find(params[:id]).destroy!
    head :no_content
  end
end
