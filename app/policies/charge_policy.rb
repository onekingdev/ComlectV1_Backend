# frozen_string_literal: true
class ChargePolicy < ApplicationPolicy
  def index?
    user.super_admin?
  end
end
