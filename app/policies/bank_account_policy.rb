# frozen_string_literal: true
class BankAccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    !record.primary?
  end
end
