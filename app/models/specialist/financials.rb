# frozen_string_literal: true
class Specialist::Financials
  attr_accessor :specialist

  def self.for(specialist)
    new.tap do |financials|
      financials.specialist = specialist
    end
  end

  PAYMENT_ORDERING = {
    'date' => 'process_after',
    'project' => 'projects.title',
    'business' => 'business.business_name',
    'amount' => 'amount_in_cents'
  }.freeze

  def self.upcoming(specialist, params)
    sort_direction = params[:sort_direction].to_s.casecmp('asc').zero? ? 'ASC' : 'DESC'
    specialist.payments
              .scheduled
              .order("#{PAYMENT_ORDERING[params[:sort_by] || 'date']} #{sort_direction}")
              .page(params[:page]).per(5)
  end

  def self.received(specialist, params)
    sort_direction = params[:sort_direction].to_s.casecmp('asc').zero? ? 'ASC' : 'DESC'
    specialist.payments
              .processed
              .order("#{PAYMENT_ORDERING[params[:sort_by] || 'date']} #{sort_direction}")
              .page(params[:page]).per(5)
  end

  def received_this_month
    @this_month ||= processed_payments.after(Time.zone.now.beginning_of_month).sum(:amount_in_cents) / 100
  end

  def upcoming_30_days
    @next_30_days ||= scheduled_payments.after(Time.zone.now).sum(:amount_in_cents) / 100
  end

  def received_ytd
    @ytd ||= processed_payments.after(Time.zone.now.beginning_of_year).sum(:amount_in_cents) / 100
  end

  def received_total
    @total ||= processed_payments.sum(:amount_in_cents) / 100
  end

  private

  def scheduled_payments
    specialist.payments.processed
  end

  def processed_payments
    specialist.payments.processed
  end
end
