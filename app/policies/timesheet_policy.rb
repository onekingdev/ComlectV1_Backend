# frozen_string_literal: true
class TimesheetPolicy < ApplicationPolicy
  def update?
    owner? && %w(pending disputed).include?(record.status)
  end

  def owner?
    record.project.specialist == user.specialist
  end
end
