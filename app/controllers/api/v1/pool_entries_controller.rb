class Api::V1::PoolEntriesController < Api::V1::BaseController
  def index
    entries = PoolEntry.includes(:participant, :driver)
    entries = entries.where(year: params[:year]) if params[:year].present?
    render json: entries, include: [:participant, :driver]
  end

  def create
    entry = PoolEntry.find_or_initialize_by(
      participant_id: pool_entry_params[:participant_id],
      driver_id:      pool_entry_params[:driver_id],
      year:           pool_entry_params[:year]
    )
    entry.assign_attributes(
      value:            pool_entry_params[:value],
      acquisition_type: pool_entry_params[:acquisition_type]
    )

    if entry.save
      status = entry.previously_new_record? ? :created : :ok
      render json: entry, status: status
    else
      render json: entry.errors, status: :unprocessable_entity
    end
  end

  def destroy
    entry = PoolEntry.find(params[:id])
    entry.destroy
    head :no_content
  end

  private

  def pool_entry_params
    params.require(:pool_entry).permit(:participant_id, :driver_id, :value, :acquisition_type, :year)
  end
end
