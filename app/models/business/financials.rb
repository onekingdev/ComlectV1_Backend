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

  def self.upcoming(business, params)
    sort_direction = params[:sort_direction].to_s.casecmp('asc').zero? ? 'ASC' : 'DESC'
    business.charges
            .upcoming
            .joins(:specialist)
            .order("#{PAYMENT_ORDERING[params[:sort_by] || 'date']} #{sort_direction}")
            .page(params[:page]).per(5)
  end

  def self.processed(business, params)
    sort_direction = params[:sort_direction].to_s.casecmp('asc').zero? ? 'ASC' : 'DESC'
    business.charges
            .processed
            .joins(:specialist)
            .order("#{PAYMENT_ORDERING[params[:sort_by] || 'date']} #{sort_direction}")
            .page(params[:page]).per(5)
  end

  def processed_this_month
    @this_month ||= processed_charges.after(Time.zone.now.beginning_of_month).sum(:amount_in_cents) / 100.0
  end

  def upcoming_30_days
    @next_30_days ||= upcoming_charges.where('date <= ?', 30.days.from_now).sum(:amount_in_cents) / 100.0
  end

  def processed_ytd
    @ytd ||= processed_charges.after(Time.zone.now.beginning_of_year).sum(:amount_in_cents) / 100.0
  end

  def processed_total
    @total ||= processed_charges.sum(:amount_in_cents) / 100.0
  end

  private

  def upcoming_charges
    business.charges.upcoming
  end

  def processed_charges
    business.charges.processed
  end
end
