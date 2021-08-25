# frozen_string_literal: true

class Roles::RisksPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    not_basic?
  end

  def update?
    not_basic?
  end

  def destroy?
    not_basic?
  end
end
