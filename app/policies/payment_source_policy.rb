# frozen_string_literal: true

class PaymentSourcePolicy < ApplicationPolicy
  def destroy?
    owner? && !record.primary?
  end

  private

  def owner?
    record.business.user_id == user.id
  end
end
