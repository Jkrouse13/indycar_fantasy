class Driver < ApplicationRecord
  belongs_to :team

  scope :active, -> { where(active: true) }
  has_many :pool_entries
  has_many :tier_drivers
  has_many :race_tiers, through: :tier_drivers
  has_one_attached :car_image

    def to_s
      "#{car_number} - #{name}"
    end

    def nickname_list
      nicknames.to_s.split(",").map(&:strip).reject(&:blank?)
    end
end
