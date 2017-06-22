# frozen_string_literal: true
class ProjectEnd < ActiveRecord::Base
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
      update_attribute :status, self.class.statuses[:confirmed]
      trigger_project_end
    end
  end

  def deny!
    update_attribute :status, self.class.statuses[:denied]
  end

  private

  def trigger_project_end
    project.update_attribute :ends_on, Time.zone.now.in_time_zone(project.business.tz)
    project.charges.upcoming.delete_all
    project.fixed_pricing? ? trigger_fixed_project_end : trigger_hourly_project_end
  end

  def trigger_fixed_project_end
    Project::Ending.process! project
  end

  def trigger_hourly_project_end
    PaymentCycle.for(project).create_charges_and_reschedule!
  end
end
