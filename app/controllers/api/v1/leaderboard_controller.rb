class Api::V1::LeaderboardController < Api::V1::BaseController
  def race
    race = Race.find(params[:race_id])
    picks = Pick.includes(:participant, :driver, :race_tier)
                .where(race: race)

    results = RaceResult.where(race: race).index_by(&:driver_id)

    participant_scores = picks.group_by(&:participant).map do |participant, participant_picks|
      total_score = participant_picks.sum do |pick|
        result = results[pick.driver_id]
        result ? result.finishing_position : 0
      end

      {
        participant: {
          id: participant.id,
          name: participant.name,
          email: participant.email
        },
        picks: participant_picks.map do |pick|
          result = results[pick.driver_id]
          {
            tier: pick.race_tier.tier_number,
            driver: {
              id: pick.driver.id,
              name: pick.driver.name,
              car_number: pick.driver.car_number
            },
            finishing_position: result ? result.finishing_position : nil
          }
        end.sort_by { |p| p[:tier] },
        total_score: total_score
      }
    end

    sorted = participant_scores.sort_by { |p| p[:total_score] }

    render json: {
      race: {
        id: race.id,
        name: race.name,
        track: race.track,
        status: race.status
      },
      leaderboard: sorted
    }
  end

  def season
    season_year = params[:season_year].to_i
    races = Race.where(season_year: season_year, status: [ :final, :live ])

    all_picks = Pick.includes(:participant, :driver)
                    .where(race: races)

    all_results = RaceResult.where(race: races).index_by { |r| [ r.race_id, r.driver_id ] }

    participant_scores = all_picks.group_by(&:participant).map do |participant, picks|
      total_score = picks.sum do |pick|
        result = all_results[[ pick.race_id, pick.driver_id ]]
        result ? result.finishing_position : 0
      end

      races_entered = picks.map(&:race_id).uniq.count

      {
        participant: {
          id: participant.id,
          name: participant.name
        },
        total_score: total_score,
        races_entered: races_entered
      }
    end

    sorted = participant_scores.sort_by { |p| p[:total_score] }

    render json: {
      season_year: season_year,
      races_counted: races.count,
      leaderboard: sorted
    }
  end
end
