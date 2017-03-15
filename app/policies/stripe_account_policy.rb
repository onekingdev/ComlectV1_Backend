# frozen_string_literal: true
class StripeAccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    !record.primary?
  end
end
