# frozen_string_literal: true
class Charge::Export
  def self.business(charges)
    CSV.generate(headers: true) do |csv|
      csv << %w(date project specialist amount outstanding_balance)
      charges.each do |charge|
        csv << [
          charge.date.strftime('%b %d, %Y'),
          charge.project.to_s,
          charge.project.specialist.to_s,
          charge.amount,
          PaymentCycle.for(charge.project).outstanding_amount
        ]
      end
    end
  end

  def self.specialist(charges)
    CSV.generate(headers: true) do |csv|
      csv << %w(date project business amount outstanding_balance)
      charges.each do |charge|
        csv << [
          charge.date.strftime('%b %d, %Y'),
          charge.project.to_s,
          charge.project.business.to_s,
          charge.amount,
          PaymentCycle.for(charge.project).outstanding_amount
        ]
      end
    end
  end
end
