# frozen_string_literal: true

class Roles::HiresPolicy < ApplicationPolicy
  def create?
    not_basic?
  end
end
