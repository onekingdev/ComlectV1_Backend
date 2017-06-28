# frozen_string_literal: true

class PaymentCycle::Hourly::UponCompletion < PaymentCycle::Hourly
  private

  def occurrences
    [project.ends_on]
  end
end
