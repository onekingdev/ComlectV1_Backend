# frozen_string_literal: true
class JobApplication::Accept < Draper::Decorator
  decorates JobApplication
  delegate_all

  def self.call(application)
    new(application).tap do |decorated|
      decorated.project.update_attribute :specialist_id, decorated.specialist_id
      decorated.schedule_full_time_fee
      decorated.send_specialist_notification
    end
  end

  def schedule_full_time_fee
    return unless project.full_time?
    project.upfront_fee? ? schedule_upfront_fee : schedule_monthly_fee
  end

  def send_specialist_notification
    # TODO: Send specialist hired notification
  end

  private

  def schedule_upfront_fee
    Charge.create! project: project,
                   process_after: project.starts_on,
                   amount_in_cents: project.annual_salary * 15, # 15%, 0.15 = 15 in cents
                   description: "Upfront fee for job hire"
  end

  def schedule_monthly_fee
    6.times do |i|
      Charge.create! project: project,
                     process_after: project.starts_on + i.months,
                     amount_in_cents: project.annual_salary * 3, # 3%, 0.03 = 3 in cents
                     description: "Monthly fee for job hire (#{i + 1} of 6)"
    end
  end
end
