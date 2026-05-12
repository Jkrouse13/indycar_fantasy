class PoolEntry < ApplicationRecord
  belongs_to :participant
  belongs_to :driver

  enum :acquisition_type, { draw: 0, auction: 1 }

  validates :value, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :year, presence: true
  validates :acquisition_type, presence: true
  validates :driver_id, uniqueness: { scope: [:participant_id, :year] }
end
