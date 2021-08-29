# frozen_string_literal: true

class Api::Business::FinancialsController < ApiController
  before_action :require_business!
  before_action :find_financials

  respond_to :json, :csv

  def processed
    @charges = Business::Financials.processed(current_business, params)
    if @charges
      respond_to do |format|
        format.json
        respond_with @charges
        format.csv do
          # Override paging to get all records
          @charges = @charges.unscope(:limit, :offset)
          send_data Charge::Export.business(@charges), filename: 'payments.csv'
        end
      end
    else
      respond_with status: :unprocessable_entity
    end
  end

  def payments
    render json: {
      processed_this_month: @financials.processed_this_month,
      upcoming_30_days: @financials.upcoming_30_days,
      processed_ytd: @financials.processed_ytd,
      processed_total: @financials.processed_total
    }
  end

  def get_budget_data
    respond_with processed_ytd: @financials.processed_ytd, annual_budget: current_business.annual_budget.to_i
  end

  def set_annual_budget
    if current_business.update_attribute(:annual_budget, params[:annual_budget])
      respond_with processed_ytd: @financials.processed_ytd, annual_budget: params[:annual_budget].to_i
    else
      respond_with status: :unprocessable_entity
    end
  end

  private

  def find_financials
    @financials = Business::Financials.for(current_business)
  end
end
