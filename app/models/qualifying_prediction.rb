class QualifyingPrediction < ApplicationRecord

  include QualifyingScoring

  belongs_to :participant

  has_many :fast_twelve_picks, dependent: :destroy
  has_many :fast_twelve_drivers, through: :fast_twelve_picks, source: :driver

  has_many :last_row_picks, dependent: :destroy
  has_many :last_row_drivers, through: :last_row_picks, source: :driver

  validates :year, presence: true, uniqueness: { scope: :participant_id }

  validate :fast_twelve_count
  validate :last_row_count
  validate :no_overlap_between_sets

  LOCKOUT_TIMES = {
    2026 => Time.find_zone("Eastern Time (US & Canada)").parse("2026-05-16 11:00:00")
  }.freeze

  def picks_locked?
    lockout = LOCKOUT_TIMES[year]
    lockout && Time.current >= lockout
  end

  def score(result)
    return zero_score unless result

    saturday_done = result.fast_twelve_drivers.any?
    sunday_done = result.pole_driver_id.present?

    my_ft_by_pos  = fast_twelve_picks.each_with_object({}) { |p, h| h[p.position] = p.driver_id if p.position }
    my_lr_by_pos  = last_row_picks.each_with_object({})   { |p, h| h[p.position] = p.driver_id if p.position }
    res_ft_set    = result.result_fast_twelves.map(&:driver_id).to_set
    res_ft_by_pos = result.result_fast_twelves.each_with_object({}) { |r, h| h[r.position] = r.driver_id if r.position }
    res_ft_by_pos[1] ||= result.pole_driver_id if result.pole_driver_id.present?
    res_lr_set    = result.result_last_rows.map(&:driver_id).to_set
    res_lr_by_pos = result.result_last_rows.each_with_object({}) { |r, h| h[r.position] = r.driver_id if r.position }

    ft_points = saturday_done ? my_ft_by_pos.sum { |pos, id|
      (res_ft_set.include?(id) ? POINTS[:fast_twelve_per_driver] : 0) +
      (res_ft_by_pos[pos] == id ? POINTS[:position_bonus] : 0)
    } : nil

    lr_points = saturday_done ? my_lr_by_pos.sum { |pos, id|
      (res_lr_set.include?(id) ? POINTS[:last_row_per_driver] : 0) +
      (res_lr_by_pos[pos] == id ? POINTS[:position_bonus] : 0)
    } : nil

    sat_points = saturday_done ? (saturday_wreck == result.saturday_wreck ? POINTS[:saturday_wreck] : 0) : nil
    sun_points = sunday_done ? (sunday_wreck == result.sunday_wreck ? POINTS[:sunday_wreck] : 0) : nil

    scored = [ft_points, lr_points, sat_points, sun_points].compact.sum

    {
      fast_twelve: ft_points,
      last_row: lr_points,
      saturday_wreck: sat_points,
      sunday_wreck: sun_points,
      total: scored,
      saturday_done: saturday_done,
      sunday_done: sunday_done
    }
  end

  private

  def zero_score
    { fast_twelve: 0, last_row: 0, saturday_wreck: 0, sunday_wreck: 0, total: 0 }
  end

  def fast_twelve_count
    errors.add(:base, "Fast 12 must have exactly 12 drivers") if fast_twelve_picks.size != 12
  end

  def last_row_count
    errors.add(:base, "Last row must have exactly 3 drivers") if last_row_picks.size != 3
  end

  def no_overlap_between_sets
    ft_ids = fast_twelve_picks.map(&:driver_id).map(&:to_i)
    lr_ids = last_row_picks.map(&:driver_id).map(&:to_i)
    errors.add(:base, "A driver cannot be in both Fast 12 and Last Row") if (ft_ids & lr_ids).any?
  end
end
