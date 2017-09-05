# frozen_string_literal: true

class BusinessPolicy < ApplicationPolicy
  PRIVATE_ATTRIBUTES = %i[business_name logo website linkedin_link].freeze

  def public_info(attribute)
    return record.public_send(attribute) if full_view?
    PRIVATE_ATTRIBUTES.include?(attribute) && record.anonymous? ? nil : record.public_send(attribute)
  end

  def full_view?
    record.public? || owner?
  end

  def update?
    owner? || user.is_a?(AdminUser)
  end

  def freeze?
    !active_projects? &&
      !full_time_projects_started_within_6_months? &&
      !one_off_projects_ended_within_1_week?
  end

  def owner?
    user && record.user_id == user.id
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

  def full_time_projects_started_within_6_months?
    project = record.projects.full_time.order(:starts_on).last
    return false unless project
    (project.starts_on + 6.months) > Time.zone.today
  end

  def one_off_projects_ended_within_1_week?
    project = record.projects.one_off.order(:ends_on).last
    return false unless project
    (project.ends_on + 1.week) > Time.zone.today
  end
end
