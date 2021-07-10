# frozen_string_literal: true

class JobApplicationPolicy < ApplicationPolicy
  def destroy?
    owner? && record.project.pending?
  end

  def owner?
    specialist? && record.specialist_id == user.specialist.id
  end

  private

  def specialist?
    user.specialist
  end
end
