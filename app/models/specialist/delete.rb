# frozen_string_literal: true

class Specialist::Delete
  attr_reader :user, :specialist

  NOT_PERMITTED_REASONS = {
    active_projects: 'You have active projects',
    one_off_projects: 'You have one off projects ended within 1 week',
    team_manager: 'Your account manages other accounts'
  }.freeze

  def initialize(user, specialist)
    @user = user
    @specialist = specialist
  end

  def call
    return false if disallowed?
    User::Delete.call(specialist.user)
    true
  end

  def disallowed?
    !SpecialistPolicy.new(user, specialist).freeze?
  end

  def not_permitted_reasons
    reasons = []
    reasons << :active_projects if specialist.projects.active.any?
    reasons << :one_off_projects if rfp_or_one_off_projects_ended_within_1_week?
    reasons << :team_manager if specialist.managed_team
    NOT_PERMITTED_REASONS.slice(*reasons).values
  end

  private

  def rfp_one_off_projects_ended_within_1_week?
    project = specialist.projects.one_off.or(specialist.projects.rfp).order(:ends_on).last
    return false unless project
    (project.ends_on + 1.week) > Time.zone.today
  end
end
