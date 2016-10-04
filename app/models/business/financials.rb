# frozen_string_literal: true
class Business::Financials
  attr_accessor :business

  def self.for(business)
    new.tap do |financials|
      financials.business = business
    end
  end

  PAYMENT_ORDERING = {
    'date' => 'process_after',
    'project' => 'projects.title',
    'specialist' => 'specialists.first_name',
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
    @this_month ||= processed_charges.after(Time.zone.now.beginning_of_month).sum(:amount_in_cents) / 100
  end

  def upcoming_30_days
    @next_30_days ||= scheduled_charges.after(Time.zone.now).sum(:amount_in_cents) / 100
  end

  def received_ytd
    @ytd ||= processed_charges.after(Time.zone.now.beginning_of_year).sum(:amount_in_cents) / 100
  end

  def received_total
    @total ||= processed_charges.sum(:amount_in_cents) / 100
  end

  private

  def scheduled_charges
    business.charges.estimated
  end

  def processed_charges
    business.charges.real
  end
end
