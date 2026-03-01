class Api::V1::RaceResultsController < Api::V1::BaseController
  def index
    results = RaceResult.includes(:driver).where(race_id: params[:race_id])
    render json: results, include: :driver
  end

  def create
    result = RaceResult.new(race_result_params)
    if result.save
      render json: result, status: :created
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  def update
    result = RaceResult.find(params[:id])
    if result.update(race_result_params)
      render json: result
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  private

  def race_result_params
    params.require(:race_result).permit(:race_id, :driver_id, :finishing_position)
  end
end
