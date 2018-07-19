# frozen_string_literal: true

class StripeAccountPolicy < ApplicationPolicy
  def create?
    !record.specialist.team
  end

  def update?
    !record.specialist.team
  end
end
