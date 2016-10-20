# frozen_string_literal: true
class ProjectExtension < ActiveRecord::Base
  belongs_to :project

  enum status: { pending: nil, confirmed: 'confirmed', denied: 'denied' }

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
