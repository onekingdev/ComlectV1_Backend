# frozen_string_literal: true
class PaymentCycle::Fixed::UponCompletion < PaymentCycle::Fixed
  private

  def occurrences
    [project.ends_on]
  end
end
