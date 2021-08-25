# frozen_string_literal: true

class Roles::AnnualReportsPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    not_basic?
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

  def clone?
    not_basic?
  end
end
