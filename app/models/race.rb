class Race < ApplicationRecord
  has_many :race_tiers
  has_many :race_results
  enum :status, { upcoming: 0, live: 1, final: 2 }
end
