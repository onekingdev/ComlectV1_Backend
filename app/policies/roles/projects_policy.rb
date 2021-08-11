# frozen_string_literal: true

class Roles::ProjectsPolicy < ApplicationPolicy
  def show?
    basic?
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
