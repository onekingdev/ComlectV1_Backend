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
    Rails.logger.info '1' * 80
    Rails.logger.info project.inspect
    Rails.logger.info self.inspect
    Rails.logger.info current_cycle_date.inspect

    ActiveRecord::Base.transaction do
      project.timesheets.pending_charge.each do |timesheet|
        schedule_charge!(
          amount: timesheet.total_due,
          date: current_cycle_date,
          description: "Timesheet #{timesheet.status_changed_at.strftime("%b %d, %Y")}",
          referenceable: timesheet
        )

        timesheet.charged!
      end
    end
  end
end
