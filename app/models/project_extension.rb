# frozen_string_literal: true

class ProjectExtension < ApplicationRecord
  belongs_to :project

  enum status: { pending: nil, confirmed: 'confirmed', denied: 'denied' }

  scope :expired, -> { pending.where('expires_at <= ?', Time.zone.now) }

  def confirm!
    self.class.transaction do
      confirmed!
      project.touch :extended_at
      trigger_project_extension
    end
  end

  def deny!
    denied!
  end

  private

  def trigger_project_extension
    project.update_attributes(ends_on: new_end_date, ends_in_24: false)
    reset_upcoming_charges
    PaymentCycle.for(project).create_charges_and_reschedule!
  end

  def reset_upcoming_charges
    project.charges.scheduled.each do |charge|
      charge.referenceable.approved! if charge.referenceable.is_a?(Timesheet)
    end

    project.charges.upcoming.delete_all
  end
end
