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
        races_entered: data[:races_entered],
        missed_races: data[:missed_races],
        penalty_score: data[:penalty_score]
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
    race_ids = races.map(&:id)

    # Build race_id → participant_id → score matrix
    race_scores = race_ids.index_with { {} }
    picks.each do |pick|
      next unless race_ids.include?(pick.race_id)
      pos = results[[pick.race_id, pick.driver_id]]&.finishing_position || 0
      race_scores[pick.race_id][pick.participant_id] = (race_scores[pick.race_id][pick.participant_id] || 0) + pos
    end

    # Average score per race among participants who picked
    race_averages = race_ids.to_h do |race_id|
      scores = race_scores[race_id].values
      avg = scores.any? ? (scores.sum.to_f / scores.size).round : 0
      [race_id, avg]
    end

    picks.group_by(&:participant).map do |participant, p_picks|
      entered = p_picks.map(&:race_id).uniq & race_ids
      missed  = race_ids - entered

      actual  = entered.sum { |rid| race_scores[rid][participant.id] || 0 }
      penalty = missed.sum  { |rid| race_averages[rid] }

      best_finish = entered.map { |rid| race_scores[rid][participant.id] || 0 }.min || 999

      [participant.id, {
        name:          participant.name.presence || participant.email,
        total_score:   actual + penalty,
        best_finish:   best_finish,
        races_entered: entered.size,
        missed_races:  missed.size,
        penalty_score: penalty
      }]
    end.to_h
  end

  def rank_participants(scores)
    scores.sort_by { |_, data| [ data[:total_score], data[:best_finish] ] }.to_h
  end
end
