# frozen_string_literal: true

class Business::Financials
  attr_accessor :business

  def self.for(business)
    new.tap do |financials|
      financials.business = business
    end
  end

  def self.upcoming(business, _params)
    select = <<-SELECT
      charges.date,
      SUM(charges.amount_in_cents) AS amount_in_cents,
      SUM(total_with_fee_in_cents) AS total_with_fee_in_cents,
      MIN(running_balance_in_cents) AS running_balance_in_cents
    SELECT
    # Group per project and date so charges for timesheets on the same date return a single line:
    business.charges
            .upcoming
            .after(Time.zone.now.beginning_of_year)
            .select(select)
            .group(:date)
  end

  def self.processed(business, _params)
    business.transactions
            .processed
            .by_year(Time.zone.now.year)
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

  private

  def upcoming_charges
    business.charges.upcoming
  end

  def processed_charges
    business.charges.processed
  end
end
