class Api::V1::ParticipantsController < Api::V1::BaseController
  def index
    render json: Participant.all
  end

    def show
      participant = Participant.find(params[:id])
      picks = participant.picks.includes(:race, :driver, :race_tier).map do |pick|
        race_result = RaceResult.find_by(race_id: pick.race_id, driver_id: pick.driver_id)

        {
          id: pick.id,
          race: {
            id: pick.race.id,
            name: pick.race.name,
            date: pick.race.date,
            status: pick.race.status
          },
          driver: {
            id: pick.driver.id,
            name: pick.driver.name,
            car_number: pick.driver.car_number,
            primary_color: pick.driver.primary_color,
            secondary_color: pick.driver.secondary_color
          },
          tier: pick.race_tier&.tier_number,
          finishing_position: race_result&.finishing_position,
          points: race_result&.points
        }
      end

      render json: {
        id: participant.id,
        name: participant.name,
        email: participant.email,
        picks: picks
      }
    end

  def create
    participant = Participant.find_or_create_by_email(participant_params[:email])
    render json: participant, status: :ok
  end

  private

  def participant_params
    params.require(:participant).permit(:name, :email)
  end
end
