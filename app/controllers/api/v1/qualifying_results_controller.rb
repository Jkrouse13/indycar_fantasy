class Api::V1::QualifyingResultsController < Api::V1::BaseController
  def show
    result = QualifyingResult
      .includes(:pole_driver, :fast_twelve_drivers, :last_row_drivers)
      .find_by!(year: params[:year])

    render json: serialize(result)
  end

  def update
    result = QualifyingResult.find_or_initialize_by(year: params[:year])

    QualifyingResult.transaction do
      result.assign_attributes(base_params)
      result.save!
      replace_fast_twelve(result)
      replace_last_row(result)
    end

    render json: serialize(result)
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def base_params
    params.require(:qualifying_result).permit(
      :pole_driver_id, :saturday_wreck, :sunday_wreck, :finalized
    )
  end

  def fast_twelve_ids
    params.dig(:qualifying_result, :fast_twelve_driver_ids) || []
  end

  def last_row_ids
    params.dig(:qualifying_result, :last_row_driver_ids) || []
  end

  def replace_fast_twelve(result)
    result.result_fast_twelves.destroy_all
    fast_twelve_ids.each_with_index do |driver_id, i|
      result.result_fast_twelves.create!(driver_id: driver_id, position: i + 1)
    end
  end

  def replace_last_row(result)
    result.result_last_rows.destroy_all
    last_row_ids.each_with_index do |driver_id, i|
      result.result_last_rows.create!(driver_id: driver_id, position: i + 1)
    end
  end

  def serialize(result)
    {
      id: result.id,
      year: result.year,
      pole_driver_id: result.pole_driver_id,
      pole_driver_name: result.pole_driver&.name,
      saturday_wreck: result.saturday_wreck,
      sunday_wreck: result.sunday_wreck,
      finalized: result.finalized,
      fast_twelve_driver_ids: result.result_fast_twelves.order(:position).pluck(:driver_id),
      last_row_driver_ids: result.result_last_rows.order(:position).pluck(:driver_id)
    }
  end
end
