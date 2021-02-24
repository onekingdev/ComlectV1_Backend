# frozen_string_literal: true

class Seat < ActiveRecord::Base
  belongs_to :business
  belongs_to :subscription
  belongs_to :team_member, dependent: :destroy, optional: true

  scope :available, -> { where(team_member_id: [nil, 0], assigned_at: nil) }
  scope :taken, -> { where.not(team_member_id: [nil, 0], assigned_at: nil) }

  def assign_to(team_member_id)
    update!(team_member_id: team_member_id, assigned_at: Time.zone.now)
  end

  def unassign
    update!(team_member_id: nil, assigned_at: nil)
  end
end
