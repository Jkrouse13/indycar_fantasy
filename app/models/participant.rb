class Participant < ApplicationRecord
  has_many :picks
  before_validation :normalize_email

  def self.find_or_create_by_email(email)
    normalized = email.downcase.strip
    find_or_create_by!(email: normalized)
  end

  private

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end
