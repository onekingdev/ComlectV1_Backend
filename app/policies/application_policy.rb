# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.is_a?(AdminUser)
  end

  def show?
    scope.where(id: record.id).exists? || user.is_a?(AdminUser)
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    user.is_a?(AdminUser)
  end

  def edit?
    update?
  end

  def destroy?
    user.is_a?(AdminUser)
  end

  def not_basic?
    if user.specialist.seat_role
      user.specialist.seat_role != 'basic'
    else
      user.specialist.specialists_business_roles.find_by(business_id: record).role != 'basic'
    end
  end

  def team?
    team_tiers = %w[team_tier_monthly team_tier_annual business_tier_monthly business_tier_annual]
    record.subscriptions.active.where(plan: team_tiers).present?
  end

  def business?
    team_tiers = %w[business_tier_monthly business_tier_annual]
    record.subscriptions.active.where(plan: team_tiers).present?
  end

  def annual_report_available?
    report = user.business.annual_reports.last
    if report
      report.created_at >= Time.zone.now.next_year(1)
    else
      true
    end
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
