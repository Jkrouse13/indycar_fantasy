class TierDriver < ApplicationRecord
  belongs_to :race_tier
  belongs_to :driver

    def to_s
      "#{driver.car_number} - #{driver.name}"
    end
end
