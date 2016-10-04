# frozen_string_literal: true
class PaymentCycle::Hourly::Monthly < PaymentCycle::Hourly
  def reschedule!
    project.charges.estimated.delete_all
    remaining_dates = occurrences.reject { |date| charge_exists?(date) }
    amounts = outstanding_amount / remaining_dates.size
    remaining_dates.each do |date|
      create_estimated_charge! amount: amounts, date: date
    end
  end

  private

  def occurrences
    # Skip first occurrence since it will be at the project's start date
    schedule.occurrences_between(project.starts_on, project.ends_on)[1..-1]
  end

  def schedule
    IceCube::Schedule.new(project.starts_on).tap do |schedule|
      schedule.add_recurrence_rule IceCube::Rule.monthly
    end
  end
end
