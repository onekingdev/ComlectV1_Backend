# frozen_string_literal: true

class Business::AnnualReportsController < ApplicationController
  def new
    @annual_report = AnnualReport.new
    @annual_report.annual_review_employees.build
    @annual_report.business_changes.build
    @annual_report.regulatory_changes.build
    @annual_report.findings.build
  end

  def create
    @annual_report = AnnualReport.new
    @annual_report.annual_review_employees.build
    @annual_report.business_changes.build
    @annual_report.regulatory_changes.build
    @annual_report.findings.build
    render 'new'
  end
end
