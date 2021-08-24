# frozen_string_literal: true

class Specialist::Invitation < ApplicationRecord
  belongs_to :team_member
  belongs_to :specialist, optional: true
  belongs_to :team, class_name: '::Team', foreign_key: :team_id

  enum status: { pending: 0, accepted: 1 }

  before_create :generate_token

  def accepted!(specialist)
    self.status = :accepted
    self.specialist = specialist
    save!
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now.to_i, rand].join)
  end
end
