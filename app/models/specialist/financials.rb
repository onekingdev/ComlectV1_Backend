# frozen_string_literal: true

class Specialist::Financials
  attr_accessor :specialist

  def self.for(specialist)
    new.tap do |financials|
      financials.specialist = specialist
    end
  end

  def self.upcoming(specialist, params)
    select = <<-SELECT
      charges.date, charges.project_id,
      SUM(charges.amount_in_cents) AS amount_in_cents,
      SUM(specialist_amount_in_cents) AS specialist_amount_in_cents,
      MIN(running_balance_in_cents) AS running_balance_in_cents
    SELECT
    # Group per project and date so charges for timesheets on the same date return a single line:
    specialist.payments
              .not_charged
              .joins(:business)
              .order("#{PAYMENT_ORDERING[params[:sort_by] || 'date']} #{sort_direction}")
              .select(select)
              .group(:project_id, :date, 'businesses.business_name', 'projects.title')
              .page(params[:page]).per(params[:per_page])
  end

  def self.processed(specialist, _params)
    specialist.transactions
              .processed
              .one_off
              .by_year(Time.zone.now.year)
  end

  def processed_this_month
    @processed_this_month ||= processed_payments.after(Time.zone.now.beginning_of_month).sum(:specialist_amount_in_cents) / 100.0
  end

  def upcoming_30_days
    @upcoming_30_days ||= upcoming_payments.where('date <= ?', 30.days.from_now).sum(:specialist_amount_in_cents) / 100.0
  end

  def processed_ytd
    @processed_ytd ||= processed_payments.after(Time.zone.now.beginning_of_year).sum(:specialist_amount_in_cents) / 100.0
  end

  def processed_total
    @processed_total ||= processed_payments.sum(:specialist_amount_in_cents) / 100.0
  end

  private

  def upcoming_payments
    specialist.payments.upcoming
  end

  def processed_payments
    specialist.payments.processed
  end
end
