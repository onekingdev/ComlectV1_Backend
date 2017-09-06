# frozen_string_literal: true

class Specialist::Delete < Draper::Decorator
  decorates Specialist

  NOT_PERMITTED_REASONS = {
    active_projects: 'You have active projects',
    one_off_projects: 'You have one off projects ended within 1 week'
  }.freeze

  def call
    return false if disallowed?
    User::Delete.call(specialist.user)
    true
  end

  def disallowed?
    !SpecialistPolicy.new(specialist.user, specialist).freeze?
  end

  def not_permitted_reasons
    reasons = []
    reasons << :active_projects if specialist.projects.active.any?
    reasons << :one_off_projects if one_off_projects_ended_within_1_week?
    NOT_PERMITTED_REASONS.slice(*reasons).values
  end

  private

  def one_off_projects_ended_within_1_week?
    project = specialist.projects.one_off.order(:ends_on).last
    return false unless project
    (project.ends_on + 1.week) > Time.zone.today
  end
end
