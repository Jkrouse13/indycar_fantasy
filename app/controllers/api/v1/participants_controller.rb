class Api::V1::ParticipantsController < Api::V1::BaseController
  def index
    render json: Participant.all
  end

  def show
    participant = Participant.find(params[:id])
    picks = participant.picks.includes(:race, :driver).map do |pick|
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
        finishing_position: pick.finishing_position,
        points: pick.points
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
