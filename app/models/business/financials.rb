# frozen_string_literal: true

class Business::Financials
  attr_accessor :business

  def self.for(business)
    new.tap do |financials|
      financials.business = business
    end
  end

  PAYMENT_ORDERING = {
    'date' => 'date',
    'project' => 'projects.title',
    'specialist' => 'specialists.first_name',
    'amount' => 'amount_in_cents'
  }.freeze

  def self.upcoming(business, params)
    sort_direction = params[:sort_direction].to_s.casecmp('desc').zero? ? 'DESC' : 'ASC'
    select = <<-SELECT
      charges.date, charges.project_id,
      SUM(charges.amount_in_cents) AS amount_in_cents,
      SUM(total_with_fee_in_cents) AS total_with_fee_in_cents,
      MIN(running_balance_in_cents) AS running_balance_in_cents
    SELECT
    # Group per project and date so charges for timesheets on the same date return a single line:
    business.charges
            .not_charged
            .joins(:specialist)
            .order("#{PAYMENT_ORDERING[params[:sort_by] || 'date']} #{sort_direction}")
            .select(select)
            .group(:project_id, :date, 'projects.title', 'specialists.first_name')
            .page(params[:page]).per(5)
  end

  def self.processed(business, params)
    sort_direction = params[:sort_direction].to_s.casecmp('asc').zero? ? 'ASC' : 'DESC'

    business.transactions
            .processed
            .joins(:specialist)
            .order("#{PAYMENT_ORDERING[params[:sort_by] || 'date']} #{sort_direction}")
            .page(params[:page]).per(5)
  end

  def processed_this_month
    @processed_this_month ||= processed_charges.after(Time.zone.now.beginning_of_month).sum(:total_with_fee_in_cents) / 100.0
  end

  def upcoming_30_days
    @upcoming_30_days ||= upcoming_charges.where('date <= ?', 30.days.from_now).sum(:total_with_fee_in_cents) / 100.0
  end

  def processed_ytd
    @processed_ytd ||= processed_charges.after(Time.zone.now.beginning_of_year).sum(:total_with_fee_in_cents) / 100.0
  end

  def processed_total
    @processed_total ||= processed_charges.sum(:total_with_fee_in_cents) / 100.0
  end

  def get_budget_data(_range_axis)
    [{ data: { 'Spent' => 2_000_000 } }, { data: { 'Annual Budget' => 3_000_000 } }]
    # @budget_data ||= [{ data: { name: 'Spent', value: 2_000_000 } }, { data: { name: 'Annual Budget', value: 3_000_000 } }]
    # @budget_data.each do |item|
    #   _range_axis.push(item[:data][:value]/1000)
    # end
    # @library ||= [{ vAxis: { ticks: ((_range_axis.min)..(_range_axis.max)).to_a } }]
  end

  private

  def upcoming_charges
    business.charges.upcoming
  end

  def processed_charges
    business.charges.processed
  end
end
