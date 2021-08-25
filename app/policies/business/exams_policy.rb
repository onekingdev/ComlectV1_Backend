# frozen_string_literal: true

class Business::ExamsPolicy < ApplicationPolicy
  def index?
    team?
  end

  def show?
    team?
  end

  def create?
    team?
  end

  def update?
    team?
  end

  def destroy?
    team?
  end

  def invite?
    team?
  end

  def uninvite?
    team?
  end
end
