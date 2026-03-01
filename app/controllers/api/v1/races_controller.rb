class Api::V1::RacesController < ApplicationController
  def index
    races = Race.all.order(date: :asc)
    render json: races
  end

  def show
    race = Race.find(params[:id])
    render json: race
  end

  def create
    race = Race.new(race_params)
    if race.save
      render json: race, status: :created
    else
      render json: race.errors, status: :unprocessable_entity
    end
  end

  def update
    race = Race.find(params[:id])
    if race.update(race_params)
      render json: race
    else
      render json: race.errors, status: :unprocessable_entity
    end
  end

  def destroy
    Race.find(params[:id]).destroy
    head :no_content
  end

  private

  def race_params
    params.require(:race).permit(:name, :track, :date, :green_flag_time, :status, :season_year)
  end
end