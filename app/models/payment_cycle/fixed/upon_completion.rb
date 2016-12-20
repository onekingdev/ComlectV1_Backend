# frozen_string_literal: true
class PaymentCycle::Fixed::UponCompletion < PaymentCycle::Fixed
  private

  def charge_description
    "Upon completion project payment"
  end

  def occurrences
    [project.ends_on]
  end
end
