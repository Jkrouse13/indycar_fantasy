class Api::V1::ParticipantsController < Api::V1::BaseController
  def index
    render json: Participant.all
  end

  def show
    render json: Participant.find(params[:id])
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
