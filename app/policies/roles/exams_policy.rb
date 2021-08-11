# frozen_string_literal: true

class Roles::ExamsPolicy < ApplicationPolicy
  def index?
    basic?
  end

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

  def invite?
    basic?
  end

  def uninvite?
    basic?
  end
end
