# frozen_string_literal: true

class Specialist::Invitation < ApplicationRecord
  belongs_to :team, foreign_key: :specialist_team_id
  belongs_to :specialist

  enum status: { pending: 0, accepted: 1 }

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
