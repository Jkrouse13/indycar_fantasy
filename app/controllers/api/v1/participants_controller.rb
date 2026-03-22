class Api::V1::ParticipantsController < Api::V1::BaseController
  def index
    render json: Participant.all
  end

  def show
    participant = Participant.find(params[:id])
    picks = participant.picks.includes(:race, :race_tier, driver: :team)
    race_ids = picks.map(&:race_id).uniq
    results = RaceResult.where(race_id: race_ids).index_by { |r| [ r.race_id, r.driver_id ] }

    # Calculate per-race ranks across all participants
    all_picks_for_races = Pick.where(race_id: race_ids)
    race_scores = Hash.new { |h, k| h[k] = Hash.new(0) }
    all_picks_for_races.each do |pick|
      result = results[[ pick.race_id, pick.driver_id ]]
      race_scores[pick.race_id][pick.participant_id] += result&.finishing_position || 0
    end
    race_ranks = race_scores.transform_values do |scores|
      scores.sort_by { |_, s| s }.each_with_index.map { |(pid, _), i| [ pid, i + 1 ] }.to_h
    end

    picks_by_race = picks.group_by(&:race).map do |race, race_picks|
      race_total = race_picks.sum do |pick|
        result = results[[ pick.race_id, pick.driver_id ]]
        result&.finishing_position || 0
      end

      {
        race: {
          id: race.id,
          name: race.name,
          date: race.date,
          status: race.status
        },
        total_score: race_total,
        rank: race.status == 'final' ? race_ranks.dig(race.id, participant.id) : nil,
        picks: race_picks.map do |pick|
          result = results[[ pick.race_id, pick.driver_id ]]
          {
            id: pick.id,
            driver: {
              id: pick.driver.id,
              name: pick.driver.name,
              car_number: pick.driver.car_number,
              team_name: pick.driver.team&.name,
              primary_color: pick.driver.primary_color,
              secondary_color: pick.driver.secondary_color
            },
            tier: pick.race_tier&.tier_number,
            finishing_position: result&.finishing_position
          }
        end.sort_by { |p| p[:tier] }
      }
    end.sort_by { |r| r[:race][:date] }.reverse

    render json: {
      id: participant.id,
      name: participant.name,
      email: participant.email,
      races: picks_by_race
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
