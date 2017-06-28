# frozen_string_literal: true

class Business::Delete < Draper::Decorator
  decorates Business

  NOT_PERMITTED_REASONS = {
    active_projects: 'You have active projects'
  }.freeze

  def call
    return false if disallowed?
    User::Delete.call(business.user)
    true
  end

  def disallowed?
    !BusinessPolicy.new(business.user, business).freeze?
  end

  def not_permitted_reasons
    reasons = []
    reasons << :active_projects if business.projects.active.any?
    NOT_PERMITTED_REASONS.slice(*reasons).values
  end
end
