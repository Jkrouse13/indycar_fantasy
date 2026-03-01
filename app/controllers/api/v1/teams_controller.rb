class Api::V1::TeamsController < Api::V1::BaseController
  def index
    render json: Team.includes(:drivers).all, include: :drivers
  end

  def show
    render json: Team.includes(:drivers).find(params[:id]), include: :drivers
  end

  def create
    team = Team.new(team_params)
    if team.save
      render json: team, status: :created
    else
      render json: team.errors, status: :unprocessable_entity
    end
  end

  def update
    team = Team.find(params[:id])
    if team.update(team_params)
      render json: team
    else
      render json: team.errors, status: :unprocessable_entity
    end
  end

  def destroy
    Team.find(params[:id]).destroy
    head :no_content
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
