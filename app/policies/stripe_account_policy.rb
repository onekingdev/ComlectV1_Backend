# frozen_string_literal: true
class StripeAccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    record.specialist.payments.pending_or_errored.empty? &&
      record.specialist.transactions.pending_or_errored.empty?
  end
end
