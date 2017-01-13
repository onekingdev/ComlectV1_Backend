# frozen_string_literal: true
class PaymentCycle::Hourly < PaymentCycle
  def estimated_total
    project.estimated_hours * project.hourly_rate
  end

  def outstanding_occurrences
    # For hourly projects lets not include past occurrences since
    # real charges are based off of timesheets not dates
    occurrences.reject { |date| date.past? || charge_exists?(date) }
  end

  def create_charges!
    date = current_cycle_date
    ActiveRecord::Base.transaction do
      project.timesheets.approved.each do |timesheet|
        schedule_charge! amount: timesheet.total_due,
                         date: date,
                         description: "Timesheet #{timesheet.approved_at.strftime("%b %d, %Y")}"
        timesheet.charged!
      end
    end
  end
end
