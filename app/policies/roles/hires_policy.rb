# frozen_string_literal: true

class Roles::HiresPolicy < ApplicationPolicy
  def create?
    basic?
  end
end
