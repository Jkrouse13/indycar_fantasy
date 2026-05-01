class QualifyingResult < ApplicationRecord

  belongs_to :pole_driver, class_name: "Driver", optional: true

  has_many :result_fast_twelves, class_name: "ResultFastTwelve", dependent: :destroy
  has_many :fast_twelve_drivers, through: :result_fast_twelves, source: :driver

  has_many :result_last_rows, class_name: "ResultLastRow", dependent: :destroy
  has_many :last_row_drivers, through: :result_last_rows, source: :driver

  validates :year, presence: true, uniqueness: true

  validate :fast_twelve_count, if: :finalized?
  validate :last_row_count, if: :finalized?
  validate :no_overlap_between_sets, if: :finalized?

  private

  def fast_twelve_count
    errors.add(:base, "Fast 12 must have exactly 12 drivers") if fast_twelve_drivers.size != 12
  end

  def last_row_count
    errors.add(:base, "Last row must have exactly 3 drivers") if last_row_drivers.size != 3
  end

  def no_overlap_between_sets
    overlap = fast_twelve_drivers.map(&:id) & last_row_drivers.map(&:id)
    errors.add(:base, "A driver cannot appear in both Fast 12 and Last Row") if overlap.any?
  end
end
