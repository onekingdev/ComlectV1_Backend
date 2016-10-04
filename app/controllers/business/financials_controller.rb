# frozen_string_literal: true
class Business::FinancialsController < ApplicationController
  before_action :require_business!

  def index
    @financials = Business::Financials.for(current_business)
  end

  def show
    @charges = {
      'upcoming' => upcoming_charges,
      'processed' => processed_charges
    }[params[:id]]

    return render_404 unless @charges

    respond_to do |format|
      format.html { render partial: params[:id], locals: { charges: @charges } }
      format.js
      format.csv do
        # Override paging to get all records
        @charges = @charges.page(1).per(100_000)
        send_data Charge::Export.to_csv(@charges), filename: 'charges.csv'
      end
    end
  end

  private

  def upcoming_charges
    Business::Financials.upcoming(current_business, params)
  end

  def processed_charges
    Business::Financials.processed(current_business, params)
  end
end
