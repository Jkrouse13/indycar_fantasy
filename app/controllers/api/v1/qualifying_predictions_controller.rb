class Api::V1::QualifyingPredictionsController < Api::V1::BaseController
  def index
    year = params.fetch(:year, 2026).to_i
    predictions = QualifyingPrediction
      .includes(:participant, :pole_pick, :fast_twelve_drivers, :last_row_drivers)
      .where(year: year)

    result = QualifyingResult.find_by(year: year)

    render json: predictions.map { |p| serialize_with_score(p, result) }
  end

  def show
    prediction = QualifyingPrediction
      .includes(:participant, :pole_pick, :fast_twelve_drivers, :last_row_drivers)
      .find_by!(participant_id: params[:id], year: params.fetch(:year, 2026).to_i)

    result = QualifyingResult.find_by(year: prediction.year)
    render json: serialize_with_score(prediction, result)
  end

  def create
    prediction = QualifyingPrediction.new(base_params)

    if prediction.picks_locked?
      render json: { error: "Picks are locked" }, status: :unprocessable_entity
      return
    end

    fast_twelve_ids.each { |id| prediction.fast_twelve_picks.build(driver_id: id) }
    last_row_ids.each    { |id| prediction.last_row_picks.build(driver_id: id) }

    if prediction.save
      render json: serialize(prediction), status: :created
    else
      render json: { errors: prediction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    prediction = QualifyingPrediction.find(params[:id])

    if prediction.picks_locked?
      render json: { error: "Picks are locked" }, status: :unprocessable_entity
      return
    end

    QualifyingPrediction.transaction do
      prediction.fast_twelve_picks.destroy_all
      prediction.last_row_picks.destroy_all
      fast_twelve_ids.each { |id| prediction.fast_twelve_picks.build(driver_id: id) }
      last_row_ids.each    { |id| prediction.last_row_picks.build(driver_id: id) }
      prediction.update!(base_params)
    end

    render json: serialize(prediction)
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def base_params
    params.require(:qualifying_prediction).permit(
      :participant_id, :year, :pole_pick_driver_id, :saturday_wreck, :sunday_wreck
    )
  end

  def fast_twelve_ids
    params.dig(:qualifying_prediction, :fast_twelve_driver_ids) || []
  end

  def last_row_ids
    params.dig(:qualifying_prediction, :last_row_driver_ids) || []
  end

  def replace_fast_twelve(prediction)
    prediction.fast_twelve_picks.destroy_all
    fast_twelve_ids.each do |driver_id|
      prediction.fast_twelve_picks.create!(driver_id: driver_id)
    end
  end

  def replace_last_row(prediction)
    prediction.last_row_picks.destroy_all
    last_row_ids.each do |driver_id|
      prediction.last_row_picks.create!(driver_id: driver_id)
    end
  end

  def serialize(prediction)
    {
      id: prediction.id,
      participant_id: prediction.participant_id,
      participant_name: prediction.participant&.name,
      year: prediction.year,
      pole_pick_driver_id: prediction.pole_pick_driver_id,
      pole_pick_name: prediction.pole_pick&.name,
      saturday_wreck: prediction.saturday_wreck,
      sunday_wreck: prediction.sunday_wreck,
      fast_twelve_driver_ids: prediction.fast_twelve_drivers.pluck(:id),
      last_row_driver_ids: prediction.last_row_drivers.pluck(:id),
      locked: prediction.picks_locked?
    }
  end

  def serialize_with_score(prediction, result)
    serialize(prediction).merge(score: prediction.score(result))
  end
end
