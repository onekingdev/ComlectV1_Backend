# frozen_string_literal: true

class Roles::CompliancePolicy < ApplicationPolicy
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

  def download?
    basic?
  end

  def publish?
    basic?
  end
end
