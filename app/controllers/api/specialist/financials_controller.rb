# frozen_string_literal: true

class Api::Specialist::FinancialsController < ApiController
  before_action :require_specialist!
  before_action :find_financials

  respond_to :json, :csv

  def processed
    @charges = Specialist::Financials.processed(current_specialist, params)
    if @charges
      respond_to do |format|
        format.json
        respond_with @charges
        format.csv do
          # Override paging to get all records
          @charges = @charges.unscope(:limit, :offset)
          send_data Charge::Export.specialist(@charges), filename: 'payments.csv'
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

  def get_revenue_data
    respond_with processed_ytd: @financials.processed_ytd, annual_revenue_goal: current_specialist.annual_revenue_goal.to_i
  end

  def set_annual_revenue
    if current_specialist.update_attribute(:annual_revenue_goal, params[:annual_revenue])
      respond_with processed_ytd: @financials.processed_ytd, annual_revenue_goal: params[:annual_revenue].to_i
    else
      respond_with status: :unprocessable_entity
    end
  end

  private

  def find_financials
    @financials = Specialist::Financials.for(current_specialist)
  end
end
