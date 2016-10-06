# frozen_string_literal: true
class JobApplication::Accept < Draper::Decorator
  decorates JobApplication
  delegate_all

  def self.call(application)
    new(application).tap do |decorated|
      decorated.project.update_attribute :specialist_id, decorated.specialist_id
      decorated.project.complete! if decorated.project.full_time?
      decorated.schedule_one_off_fees
      decorated.schedule_full_time_fees
      decorated.send_specialist_notification
    end
  end

  def schedule_one_off_fees
    return unless project.one_off?
    PaymentCycle.for(project).reschedule!
  end

  def schedule_full_time_fees
    return unless project.full_time?
    project.upfront_fee? ? schedule_upfront_fee : schedule_monthly_fee
  end

  def send_specialist_notification
    HireMailer.deliver_later :hired, model
  end

  private

  def schedule_upfront_fee
    project.charges.create! amount_in_cents: project.annual_salary * 15, # 15% in cents
                            date: project.starts_on,
                            process_after: project.starts_on,
                            status: Charge.statuses[:scheduled],
                            description: "Upfront fee for job hire"
  end

  def schedule_monthly_fee
    6.times do |i|
      Charge.create! project: project,
                     date: project.starts_on + i.months,
                     process_after: project.starts_on + i.months,
                     amount_in_cents: project.annual_salary * 3, # 3%, 0.03 = 3 in cents
                     description: "Monthly fee for job hire (#{i + 1} of 6)"
    end
  end
end
