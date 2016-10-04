# frozen_string_literal: true
class PaymentCycle::Fixed::FiftyFifty < PaymentCycle::Fixed
  def reschedule!
    # Create first real charge right away
    schedule_charge! amount: estimated_total / 2.0, date: project.starts_on, description: "First 50/50 charge"
    # Schedule second charge normally
    super
  end

  private

  def occurrences
    [project.starts_on, project.ends_on]
  end
end
