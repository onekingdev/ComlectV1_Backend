# frozen_string_literal: true
class Admin::ChargePolicy < AdminPolicy
  def update?
    record.scheduled?
  end

  def destroy?
    !record.processed?
  end
end
