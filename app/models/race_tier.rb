class RaceTier < ApplicationRecord
  belongs_to :race
  has_many :tier_drivers
  has_many :drivers, through: :tier_drivers
  has_many :picks
end
