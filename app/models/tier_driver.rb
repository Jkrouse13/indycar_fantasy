class TierDriver < ApplicationRecord
  belongs_to :race_tier
  belongs_to :driver
end
