# frozen_string_literal: true

class Roles::AnnualReportsPolicy < ApplicationPolicy
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

  def clone?
    basic?
  end
end
