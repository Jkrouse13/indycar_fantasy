class Pick < ApplicationRecord
  belongs_to :participant
  belongs_to :race
  belongs_to :race_tier
  belongs_to :driver
end
