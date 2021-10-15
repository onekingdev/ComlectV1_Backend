# frozen_string_literal: true

class ProjectEnd < ApplicationRecord
  belongs_to :project

  enum status: {
    pending: nil,
    confirmed: 'confirmed',
    denied: 'denied'
  }

  scope :expired, -> {
    pending
      .where("#{table_name}.expires_at <= ?", Time.zone.now)
      .joins(:project)
      .merge(Project.published)
  }

  def confirm!
    self.class.transaction do
      update_attribute(:status, self.class.statuses[:confirmed])
      trigger_project_end
    end
  end

  def deny!
    update_attribute(:status, self.class.statuses[:denied])
  end

  private

  def trigger_project_end
    project.update_attribute(:ends_on, Time.zone.now.in_time_zone(project.business.tz))
    project.complete!
    remove_permission
    reset_upcoming_charges
    project.fixed_pricing? ? trigger_fixed_project_end : trigger_hourly_project_end
  end

  def trigger_fixed_project_end
    Project::Ending.process!(project)
  end

  def trigger_hourly_project_end
    PaymentCycle.for(project).create_charges_and_reschedule!
  end

  def reset_upcoming_charges
    project.charges.scheduled.each do |charge|
      charge.referenceable.approved! if charge.referenceable.is_a?(Timesheet)
    end

    project.charges.upcoming.delete_all
  end

  def remove_permission
    active_project_ids = project.specialist.active_projects.where(business_id: project.business.id).ids
    if active_project_ids.empty?
      role = SpecialistsBusinessRole.find_by(business_id: project.business_id, specialist_id: project.specialist_id)
      role&.update(status: :inactive)
    end
  end
end
