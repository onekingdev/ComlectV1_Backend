# frozen_string_literal: true
class PaymentCycle::Hourly::UponCompletion < PaymentCycle::Hourly
  def create_charges!
    # Only charge after project is deemed complete
    super if project.complete?
  end

  private

  def occurrences
    [project.ends_on]
  end
end
