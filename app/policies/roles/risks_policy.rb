# frozen_string_literal: true

class Roles::RisksPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    basic?
  end

  def update?
    basic?
  end

  def destroy?
    basic?
  end
end
