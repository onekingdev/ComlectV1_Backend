# frozen_string_literal: true
class AdminUserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.super_admin?
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def new?
    create?
  end

  def create?
    user.super_admin?
  end

  def edit?
    update?
  end

  def update?
    user.super_admin?
  end

  def destroy?
    false
  end

  def destroy_all?
    false
  end

  def toggle_suspend?
    user.super_admin? && user != record
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end
end
