# frozen_string_literal: true
class Specialists::FinancialsController < ApplicationController
  before_action :require_specialist!

  def index
    @financials = Specialist::Financials.for(current_specialist)
  end

  def show
    @payments = {
      'upcoming' => upcoming_payments,
      'received' => received_payments
    }[params[:id]]

    return render_404 unless @payments

    respond_to do |format|
      format.html { render partial: params[:id], locals: { payments: @payments } }
      format.js
      format.csv do
        # Override paging to get all records
        @payments = @payments.unscope(:limit, :offset)
        send_data Charge::Export.specialist(@payments), filename: 'payments.csv'
      end
    end
  end

  private

  def upcoming_payments
    Specialist::Financials.upcoming(current_specialist, params)
  end

  def received_payments
    Specialist::Financials.received(current_specialist, params)
  end
end
