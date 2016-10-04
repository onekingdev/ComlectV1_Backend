# frozen_string_literal: true
class PaymentCycle::Hourly::BiWeekly < PaymentCycle::Hourly
  def reschedule!
    project.charges.estimated.delete_all
    remaining_dates = occurrences.reject { |date| charge_exists?(date) }
    amounts = outstanding_amount / remaining_dates.size
    remaining_dates.each do |date|
      create_estimated_charge! amount: amounts, date: date
    end
  end

  def create_charges!
    date = current_cycle_date
    ActiveRecord::Base.transaction do
      project.timesheets.approved.each do |timesheet|
        schedule_charge! amount: timesheet.total_due,
                         date: date,
                         description: "Timesheet #{timesheet.id}"
        timesheet.charged!
      end
    end
  end

  def charge_current!(amount:, description:)
    date = current_cycle_date
    project.charges.create! amount_in_cents: amount * 100,
                            status: Project.statuses[:scheduled],
                            date: date,
                            process_after: calculate_process_at_date(date),
                            description: description
  end

  private

  def current_cycle_date
    all_occurrences = occurrences
    all_occurrences.detect(&:future?) || all_occurrences.last
  end

  def occurrences
    # Skip first occurrence since it will be at the project's start date
    schedule.occurrences_between(project.starts_on, project.ends_on)[1..-1]
  end

  def schedule
    IceCube::Schedule.new(project.starts_on).tap do |schedule|
      schedule.add_recurrence_rule IceCube::Rule.weekly(2)
    end
  end
end
