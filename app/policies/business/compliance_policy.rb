# frozen_string_literal: true

class Business::CompliancePolicy < ApplicationPolicy
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

  def download?
    team?
  end

  def publish?
    team?
  end
end
