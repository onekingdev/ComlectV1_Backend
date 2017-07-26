# frozen_string_literal: true

class TimesheetPolicy < ApplicationPolicy
  def process?
    business_owner? && record.submitted?
  end

  def create?
    # Only specialist assigned to project that is not escalated/completed
    specialist? && assigned_to_project? && active_project?
  end

  def update?
    owner? && %w[pending disputed].include?(record.status)
  end

  def destroy?
    (super || owner?) && (record.pending? || record.submitted? || record.disputed?)
  end

  def business_owner?
    record.business == user.business
  end

  def owner?
    record.specialist == user.specialist
  end

  private

  def specialist?
    user.specialist
  end

  def assigned_to_project?
    record.project.specialist_id == user.specialist.id
  end

  def active_project?
    record.project.active?
  end

  def disputed_project?
    record.project.timesheets.disputed.where.not(id: record.id).exists?
  end
end
