# frozen_string_literal: true

class Business::AnnualReportsPolicy < ApplicationPolicy
  # allow only 1 / year
  def index?
    team?
  end

  def show?
    team?
  end

  def create?
    annual_report_available? && team?
  end

  def update?
    team?
  end

  def destroy?
    team?
  end

  def clone?
    annual_report_available? && team?
  end
end
