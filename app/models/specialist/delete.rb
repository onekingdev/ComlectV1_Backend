# frozen_string_literal: true
class Specialist::Delete < Draper::Decorator
  decorates Specialist

  NOT_PERMITTED_REASONS = {
    active_projects: 'You have active projects'
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
    NOT_PERMITTED_REASONS.slice(*reasons).values
  end
end
