# frozen_string_literal: true

class Business::CompliancePolicyPolicy < ApplicationPolicy
  def index?
    team?
  end

  def show?
    team?
  end

  def destroy?
    true
  end

  def download_all?
    true
  end

  def combined_policy?
    true
  end

  def update_position?
    true
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
