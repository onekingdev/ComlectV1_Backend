# frozen_string_literal: true
class ProjectExtension < ActiveRecord::Base
  belongs_to :project

  enum status: { pending: nil, confirmed: 'confirmed', denied: 'denied' }

  def confirm!
    self.class.transaction do
      update_attribute :status, self.class.statuses[:confirmed]
      PaymentCycle.for(project).reschedule!
    end
  end

  def deny!
    update_attribute :status, self.class.statuses[:denied]
  end
end
