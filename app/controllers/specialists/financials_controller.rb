# frozen_string_literal: true
class Specialists::FinancialsController < ApplicationController
  before_action :require_specialist!

  def index
    @financials = Specialist::Financials.for(current_specialist)
  end

  def show
    @payments = {
      'upcoming' => upcoming_payments,
      'processed' => processed_payments
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

  def invoice
    respond_to do |format|
      format.pdf do
        render pdf: 'invoice',
               template: 'specialists/financials/invoice.pdf.erb',
               locals: { charge: Charge.find(params[:id]) },
               margin: { top:               0,
                         bottom:            0,
                         left:              0,
                         right:             0 }
      end
    end
  end

  private

  def upcoming_payments
    Specialist::Financials.upcoming(current_specialist, params)
  end

  def processed_payments
    Specialist::Financials.processed(current_specialist, params)
  end
end
