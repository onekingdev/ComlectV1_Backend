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
    PaymentCycle.for(project).charge_current!(
      amount: project.annual_salary * 0.15, # 15%
      description: "Upfront fee for job hire"
    )
  end

  def schedule_monthly_fee
    payment_cycle = PaymentCycle.for(project)
    # Push to monday: add two days for saturday, add one day for sunday
    adjust_dates = Hash.new(0).merge(6 => 2.days, 0 => 1.day)
    6.times do |i|
      date = project.starts_on + i.months
      date += adjust_dates[date.wday]
      payment_cycle.schedule_charge! amount: project.annual_salary * 0.03, # 3%
                                     date: date,
                                     description: "Monthly fee for job hire (#{i + 1} of 6)"
    end
  end
end
