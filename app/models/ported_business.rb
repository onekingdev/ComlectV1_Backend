# frozen_string_literal: true

class PortedBusiness < ActiveRecord::Base
  belongs_to :specialist, optional: true

  before_create :generate_token

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  validates :email, format: { with: Devise.email_regexp }
  validates :company, presence: true

  def accept(business_id)
    update(status: 1, business_id: business_id)
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([email, Time.now.to_i, rand].join)
  end

  def self.ported?(business_id, specialist_id)
    where(business_id: business_id, specialist_id: specialist_id, status: 1).exists?
  end
end
