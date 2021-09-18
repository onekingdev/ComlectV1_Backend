# frozen_string_literal: true

module ModelHelper
  def amount_with_stripe_fee_card(amount)
    ((BigDecimal((amount + 0.3).to_s) / (1 - 0.029)) * 100).round
  end

  def stripe_fee_bank(amount)
    fee = ((BigDecimal(amount.to_s) / (1 - 0.008)) * 100).round - (BigDecimal(amount.to_s) * 100).to_i
    fee > 500 ? 500 : fee
  end

  def amount_with_stripe_fee_bank(amount)
    stripe_fee_bank(amount) + (amount * 100).to_i
  end

  def log_timesheet(project, hours:, status: Timesheet.statuses[:approved])
    build(:timesheet, project: project, status: status).tap do |timesheet|
      timesheet.time_logs << build(:time_log, timesheet: timesheet, hours: hours)
      timesheet.save!
    end
  end
end
