# frozen_string_literal: true

class Business::AnnualReportsController < ApplicationController
  before_action :require_business!

  def new
    if current_business.annual_reports.any?
      @annual_report = current_business.annual_reports.last
    else
      @annual_report = AnnualReport.create(business_id: current_business.id)
      @annual_report.annual_review_employees.build
      @annual_report.business_changes.build
      @annual_report.regulatory_changes.build
      @annual_report.findings.build
      @annual_report.save
    end
  end

  def create
    @prms = params['annual_report']['cof_bits']
    @annual_report = AnnualReport.new(annual_report_params)
    @cof_bits = @prms.keys.map(&:to_i) unless @prms.nil?
    unless @cof_bits.nil?
      total = 0
      @cof_bits.each do |k|
        total += (10**k).to_s.to_i(2)
      end
      @annual_report.cof_bits = total
    end
    # render 'new'
    respond_to do |format|
      format.pdf do
        render pdf: 'Annual_Report',
               template: 'business/annual_reports/annual_report.pdf.erb',
               locals: { annual_report: @annual_report, business: current_business },
               margin: { top:               20,
                         bottom:            25,
                         left:              15,
                         right:             15 }
      end
    end
  end

  def update
    @annual_report = AnnualReport.find(params[:id])
    if @annual_report.business_id == current_business.id
      @annual_report.update(annual_report_params)
      @prms = params['annual_report']['cof_bits']
      @cof_bits = @prms.keys.map(&:to_i) unless @prms.nil?
      unless @cof_bits.nil?
        total = 0
        @cof_bits.each do |k|
          total += (10**k).to_s.to_i(2)
        end
        @annual_report.update(cof_bits: total)
      end
    end
    redirect_to new_business_annual_report_path
  end

  private

  def annual_report_params
    # rubocop:disable Metrics/LineLength
    params.require(:annual_report).permit(:exam_start, :exam_end, :review_start, :review_end, :tailored_lvl, :cof_bits, :comments, annual_review_employees_attributes: %i[id name title department _destroy], business_changes_attributes: %i[id change _destroy], regulatory_changes_attributes: %i[id change response _destroy], findings_attributes: %i[id finding action risk_lvl _destroy])
    # rubocop:enable Metrics/LineLength
  end
end
