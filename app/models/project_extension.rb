# frozen_string_literal: true
class ProjectExtension < ActiveRecord::Base
  belongs_to :project

  enum status: { pending: nil, confirmed: 'confirmed', denied: 'denied' }

  scope :expired, -> { pending.where('expires_at <= ?', Time.zone.now) }

  def confirm!
    self.class.transaction do
      confirmed!
      project.touch :extended_at
      PaymentCycle.for(project).reschedule!
    end
  end

  def deny!
    denied!
  end
end
