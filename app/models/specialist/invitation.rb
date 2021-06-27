# frozen_string_literal: true

class Specialist::Invitation < ApplicationRecord
  belongs_to :team, class_name: '::Team', foreign_key: :team_id
  belongs_to :specialist, optional: true

  enum status: { pending: 0, accepted: 1 }
  enum role: { basic: 0, admin: 1, trusted: 2 }

  before_create :generate_token

  auto_strip_attributes :first_name, :last_name, :email

  def accepted!(specialist)
    self.status = :accepted
    self.specialist = specialist
    save!
  end

  def full_name
    [first_name, last_name].map(&:presence).compact.join(' ')
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([email, Time.now.to_i, rand].join)
  end
end
