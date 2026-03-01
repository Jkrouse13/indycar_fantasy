class Api::V1::PicksController < ApplicationController
  def index
    picks = Pick.includes(:participant, :driver, :race_tier).where(race_id: params[:race_id])
    render json: picks, include: [:participant, :driver, :race_tier]
  end

  def create
    race = Race.find(pick_params[:race_id])
    if race.live? || race.final?
      render json: { error: "Picks are locked" }, status: :unprocessable_entity
      return
    end

    pick = Pick.new(pick_params)
    if pick.save
      render json: pick, status: :created
    else
      render json: pick.errors, status: :unprocessable_entity
    end
  end

  private

  def pick_params
    params.require(:pick).permit(:participant_id, :race_id, :race_tier_id, :driver_id)
  end
end