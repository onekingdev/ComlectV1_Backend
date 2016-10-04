# frozen_string_literal: true
class Business::FinancialsController < ApplicationController
  before_action :require_business!

  def index
    @financials = Business::Financials.for(current_business)
  end

  def show
    @charges = {
      'upcoming' => upcoming_payments,
      'received' => received_payments
    }[params[:id]]

    return render_404 unless @charges

    respond_to do |format|
      format.html { render partial: params[:id], locals: { payments: @charges } }
      format.js
      format.csv do
        # Override paging to get all records
        @charges = @charges.page(1).per(100_000)
        send_data Charge::Export.to_csv(@charges), filename: 'payments.csv'
      end
    end
  end

  private

  def upcoming_payments
    Business::Financials.upcoming(current_specialist, params)
  end

  def received_payments
    Business::Financials.received(current_specialist, params)
  end
end
