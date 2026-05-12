class Api::V1::PicksController < Api::V1::BaseController
  def index
    picks = Pick.includes(:participant, :driver, :race_tier).where(race_id: params[:race_id])
    render json: picks, include: [ :participant, :driver, :race_tier ]
  end

  def create
    race = Race.find(pick_params[:race_id])
    if race.live? || race.final?
      render json: { error: "Picks are locked" }, status: :unprocessable_entity
      return
    end

    pick = Pick.find_or_initialize_by(
      participant_id: pick_params[:participant_id],
      race_id: pick_params[:race_id],
      race_tier_id: pick_params[:race_tier_id]
    )
    pick.driver_id = pick_params[:driver_id]

    if pick.save
      status = pick.previously_new_record? ? :created : :ok
      render json: pick, status: status
    else
      render json: pick.errors, status: :unprocessable_entity
    end
  end

  private

  def pick_params
    params.require(:pick).permit(:participant_id, :race_id, :race_tier_id, :driver_id)
  end
end
