# frozen_string_literal: true
class Specialist::Financials
  attr_accessor :specialist

  def self.for(specialist)
    new.tap do |financials|
      financials.specialist = specialist
    end
  end

  PAYMENT_ORDERING = {
    'date' => 'date',
    'project' => 'projects.title',
    'business' => 'businesses.business_name',
    'amount' => 'amount_in_cents'
  }.freeze

  def self.upcoming(specialist, params)
    sort_direction = params[:sort_direction].to_s.casecmp('desc').zero? ? 'DESC' : 'ASC'
    select = <<-SELECT
      charges.date, charges.project_id,
      SUM(amount_in_cents) AS amount_in_cents,
      SUM(specialist_amount_in_cents) AS specialist_amount_in_cents,
      MIN(running_balance_in_cents) AS running_balance_in_cents
    SELECT
    # Group per project and date so charges for timesheets on the same date return a single line:
    specialist.payments
              .upcoming
              .joins(:business)
              .order("#{PAYMENT_ORDERING[params[:sort_by] || 'date']} #{sort_direction}")
              .select(select)
              .group(:project_id, :date, 'businesses.business_name', 'projects.title')
              .page(params[:page]).per(5)
  end

  def self.processed(specialist, params)
    sort_direction = params[:sort_direction].to_s.casecmp('asc').zero? ? 'ASC' : 'DESC'
    specialist.transactions
              .one_off
              .joins(:business)
              .order("#{PAYMENT_ORDERING[params[:sort_by] || 'date']} #{sort_direction}")
              .page(params[:page]).per(5)
  end

  def processed_this_month
    @this_month ||= processed_payments.after(Time.zone.now.beginning_of_month).sum(:specialist_amount_in_cents) / 100.0
  end

  def upcoming_30_days
    @next_30_days ||= upcoming_payments.where('date <= ?', 30.days.from_now).sum(:specialist_amount_in_cents) / 100.0
  end

  def processed_ytd
    @ytd ||= processed_payments.after(Time.zone.now.beginning_of_year).sum(:specialist_amount_in_cents) / 100.0
  end

  def processed_total
    @total ||= processed_payments.sum(:specialist_amount_in_cents) / 100.0
  end

  private

  def upcoming_payments
    specialist.payments.upcoming
  end

  def processed_payments
    specialist.payments.processed
  end
end
