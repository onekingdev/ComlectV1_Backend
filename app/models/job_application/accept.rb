# frozen_string_literal: true
class JobApplication::Accept < Draper::Decorator
  decorates JobApplication
  delegate_all

  include NotificationsHelper

  def self.call(application)
    ActiveRecord::Base.transaction do
      new(application).tap do |decorated|
        decorated.project.update_attribute :specialist_id, decorated.specialist_id
        decorated.project.complete! if decorated.project.full_time?
        decorated.schedule_one_off_fees
        decorated.schedule_full_time_fees
        decorated.send_specialist_notification
        decorated.notify_not_selected_applicants
        decorated.project.touch :hired_at
      end
    end
  end

  def schedule_one_off_fees
    return unless project.one_off?
    ScheduleChargesJob.perform_later project.id
  end

  def schedule_full_time_fees
    return unless project.full_time?
    project.upfront_fee? ? schedule_upfront_fee : schedule_monthly_fee
  end

  def notify_not_selected_applicants
    project.job_applications.includes(:specialist).where.not(id: id).find_each do |application|
      Notification::Deliver.not_hired!(application)
    end
  end

  def send_specialist_notification
    Notification::Deliver.got_hired! self
  end

  private

  def schedule_upfront_fee
    project.charges.create! amount_in_cents: 0,
                            fee_in_cents: project.annual_salary * 15, # 15% in cents,
                            date: project.starts_on,
                            process_after: project.starts_on,
                            status: Charge.statuses[:scheduled],
                            description: "Full-time fee payable to Complect; Payment option: Upfront"
  end

  def schedule_monthly_fee
    6.times do |i|
      Charge.create! project: project,
                     date: project.starts_on + i.months,
                     process_after: project.starts_on + i.months,
                     amount_in_cents: 0,
                     fee_in_cents: project.annual_salary * 3, # 3%, 0.03 = 3 in cents,
                     description: "Full-time fee payable to Complect; Payment option: Monthly"
    end
  end
end
