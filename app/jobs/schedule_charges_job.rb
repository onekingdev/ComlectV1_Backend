# frozen_string_literal: true
class ScheduleChargesJob < ActiveJob::Base
  queue_as :default

  def perform(project_id = nil)
    return schedule_all if project_id.nil?
    project = Project.find_by(id: project_id)
    PaymentCycle.for(project).create_charges_and_reschedule! if project
  end

  private

  def schedule_all
    Project.active.pluck(:id).each do |project_id|
      self.class.perform_later project_id
    end
  end
end
