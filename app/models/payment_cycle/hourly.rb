# frozen_string_literal: true
class PaymentCycle::Hourly < PaymentCycle
  def estimated_total
    project.estimated_hours * project.hourly_rate
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
end
