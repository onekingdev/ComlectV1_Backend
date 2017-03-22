# frozen_string_literal: true
class ProjectEnd < ActiveRecord::Base
  belongs_to :project

  enum status: { pending: nil, confirmed: 'confirmed', denied: 'denied' }

  scope :expired, -> { pending.where('expires_at <= ?', Time.zone.now) }

  def confirm!
    self.class.transaction do
      update_attribute :status, self.class.statuses[:confirmed]
      project.update_attribute :ends_on, Time.zone.now
      project.charges.upcoming.delete_all
      PaymentCycle.for(project).create_charges_and_reschedule!
    end
  end

  def deny!
    update_attribute :status, self.class.statuses[:denied]
  end
end
