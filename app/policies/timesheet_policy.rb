# frozen_string_literal: true
class TimesheetPolicy < ApplicationPolicy
  def process?
    business_owner? && record.submitted?
  end

  def update?
    owner? && %w(pending disputed).include?(record.status)
  end

  def destroy?
    super && (record.pending? || record.submitted? || record.disputed?)
  end

  def business_owner?
    record.business == user.business
  end

  def owner?
    record.specialist == user.specialist
  end
end
