# frozen_string_literal: true

class Business::AnnualReportsController < ApplicationController
  before_action :require_business!

  def new
    @annual_report = AnnualReport.new
    @annual_report.annual_review_employees.build
    @annual_report.business_changes.build
    @annual_report.regulatory_changes.build
    @annual_report.findings.build
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

  private

  def annual_report_params
    # rubocop:disable Metrics/LineLength
    params.require(:annual_report).permit(:exam_start, :exam_end, :review_start, :review_end, :tailored_lvl, :cof_bits, :comments, annual_review_employees_attributes: %i[name title department], business_changes_attributes: [:change], regulatory_changes_attributes: %i[change response], findings_attributes: %i[finding action risk_lvl])
    # rubocop:enable Metrics/LineLength
  end
end
