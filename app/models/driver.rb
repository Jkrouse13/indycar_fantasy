class Driver < ApplicationRecord
  belongs_to :team
  has_many :tier_drivers
  has_many :race_tiers, through: :tier_drivers
  has_one_attached :car_image
end
