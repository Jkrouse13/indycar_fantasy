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
          name: participant.name.presence || participant.email
        },
        picks: participant_picks.map do |pick|
          result = results[pick.driver_id]
          {
            tier: pick.race_tier.tier_number,
            driver: {
              id: pick.driver.id,
              name: pick.driver.name,
              car_number: pick.driver.car_number,
              team_name: pick.driver.team&.name,
              primary_color: pick.driver.primary_color,
              secondary_color: pick.driver.secondary_color
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
    races = Race.where(season_year: season_year, status: [ :final, :live ]).order(:date)

    all_picks = Pick.includes(:participant, :driver).where(race: races)
    all_results = RaceResult.where(race: races).index_by { |r| [ r.race_id, r.driver_id ] }

    # Current season scores
    current_scores = calculate_scores(all_picks, all_results, races)
    current_ranking = rank_participants(current_scores)

    # Previous scores (exclude the most recent race)
    if races.count > 1
      previous_races = races[0..-2]
      previous_picks = all_picks.select { |p| previous_races.map(&:id).include?(p.race_id) }
      previous_results = all_results.select { |k, _| previous_races.map(&:id).include?(k[0]) }
      previous_scores = calculate_scores(previous_picks, previous_results, previous_races)
      previous_ranking = rank_participants(previous_scores)
    else
      previous_ranking = {}
    end

    # Build leaderboard with trend
    leaderboard = current_ranking.each_with_index.map do |(participant_id, data), index|
      current_pos = index + 1
      previous_pos = previous_ranking.keys.index(participant_id)&.+(1)

      trend = if previous_pos.nil?
        "new"
      elsif current_pos < previous_pos
        "up"
      elsif current_pos > previous_pos
        "down"
      else
        "same"
      end

      {
        position: current_pos,
        trend: trend,
        trend_amount: previous_pos ? (previous_pos - current_pos).abs : nil,
        participant: {
          id: participant_id,
          name: data[:name]
        },
        total_score: data[:total_score],
        best_finish: data[:best_finish],
        races_entered: data[:races_entered]
      }
    end

    render json: {
      season_year: season_year,
      races_counted: races.count,
      leaderboard: leaderboard
    }
  end

  private

  def calculate_scores(picks, results, races)
    picks.group_by(&:participant).map do |participant, participant_picks|
      total_score = participant_picks.sum do |pick|
        result = results[[ pick.race_id, pick.driver_id ]]
        result ? result.finishing_position : 0
      end

      best_finish = participant_picks.map do |pick|
        result = results[[ pick.race_id, pick.driver_id ]]
        result ? result.finishing_position : 999
      end.min

      [ participant.id, {
        name: participant.name.presence || participant.email,
        total_score: total_score,
        best_finish: best_finish,
        races_entered: participant_picks.map(&:race_id).uniq.count
      } ]
    end.to_h
  end

  def rank_participants(scores)
    scores.sort_by { |_, data| [ data[:total_score], data[:best_finish] ] }.to_h
  end
end
