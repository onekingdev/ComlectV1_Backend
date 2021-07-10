# frozen_string_literal: true

class Specialist::InvitationPolicy < ApplicationPolicy
  def owner?
    record.team&.manager == user.specialist
  end

  def destroy?
    (super || owner?) && record.pending?
  end
end
