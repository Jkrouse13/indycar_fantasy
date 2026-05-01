class QualifyingPrediction < ApplicationRecord

  include QualifyingScoring

  belongs_to :participant
  belongs_to :pole_pick, class_name: "Driver", foreign_key: :pole_pick_driver_id, optional: true

  has_many :fast_twelve_picks, dependent: :destroy
  has_many :fast_twelve_drivers, through: :fast_twelve_picks, source: :driver

  has_many :last_row_picks, dependent: :destroy
  has_many :last_row_drivers, through: :last_row_picks, source: :driver

  validates :year, presence: true, uniqueness: { scope: :participant_id }

  validate :fast_twelve_count
  validate :last_row_count
  validate :no_overlap_between_sets
  validate :pole_pick_in_fast_twelve

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

    my_fast_twelve = fast_twelve_drivers.pluck(:id).to_set
    my_last_row = last_row_drivers.pluck(:id).to_set

    ft_points = saturday_done ? (my_fast_twelve & result.fast_twelve_drivers.pluck(:id).to_set).size * POINTS[:fast_twelve_per_driver] : nil
    lr_points = saturday_done ? (my_last_row & result.last_row_drivers.pluck(:id).to_set).size * POINTS[:last_row_per_driver] : nil
    sat_points = saturday_done ? (saturday_wreck == result.saturday_wreck ? POINTS[:saturday_wreck] : 0) : nil
    pole_points = sunday_done ? (pole_pick_driver_id == result.pole_driver_id ? POINTS[:pole] : 0) : nil
    sun_points = sunday_done ? (sunday_wreck == result.sunday_wreck ? POINTS[:sunday_wreck] : 0) : nil

    scored = [ft_points, lr_points, sat_points, pole_points, sun_points].compact.sum

    {
      fast_twelve: ft_points,
      last_row: lr_points,
      saturday_wreck: sat_points,
      pole: pole_points,
      sunday_wreck: sun_points,
      total: scored,
      saturday_done: saturday_done,
      sunday_done: sunday_done
    }
  end

  private

  def zero_score
    { fast_twelve: 0, last_row: 0, pole: 0, saturday_wreck: 0, sunday_wreck: 0, total: 0 }
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

  def pole_pick_in_fast_twelve
    return if pole_pick_driver_id.nil?
    ft_ids = fast_twelve_picks.map(&:driver_id).map(&:to_i)
    errors.add(:pole_pick, "must be one of your Fast 12 picks") unless ft_ids.include?(pole_pick_driver_id.to_i)
  end
end
