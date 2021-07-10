# frozen_string_literal: true

class SpecialistPolicy < ApplicationPolicy
  def update?
    owner? || user.is_a?(AdminUser)
  end

  def owner?
    user && record.user_id == user.id
  end

  def freeze?
    !active_projects? &&
      !rfp_or_one_off_projects_ended_within_1_week? &&
      !team_manager? &&
      manages_account?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

  private

  def active_projects?
    record.projects.active.any?
  end

  def team_manager?
    record.managed_team
  end

  def manages_account?
    return true unless record.team
    user.specialist == record.team&.manager
  end

  def rfp_or_one_off_projects_ended_within_1_week?
    project = record.projects.one_off.or(record.projects.rfp).order(:ends_on).last
    return false unless project
    (project.ends_on + 1.week) > Time.zone.today
  end
end
