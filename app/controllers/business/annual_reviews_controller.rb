# frozen_string_literal: true

class Business::AnnualReviewsController < ApplicationController
  before_action :set_review, only: %i[update edit show]
  before_action :require_business!

  def index
    avail_prices = [[1500, 2000, 2500], [2000, 2500, 3000]]
    @prices = current_business.employees_cnt > 10 ? avail_prices[1] : avail_prices[0]
  end

  def new
    @annual_review = AnnualReview.new
    #  @compliance_policy = CompliancePolicy.new
    #  @compliance_policy.compliance_policy_docs.build
  end

  def create
    @annual_review = AnnualReview.new(annual_review_params)
    @annual_review.business_id = current_business.id
    if @annual_review.save
      PdfReviewWorker.perform_async(@annual_review.id)
      redirect_to business_annual_review_path(@annual_review)
    else
      render 'new'
    end
  end

  def update
    if @annual_review.update(annual_review_params)
      PdfReviewWorker.perform_async(@annual_review.id)
      redirect_to business_annual_review_path(@annual_review)
    else
      render 'new'
    end
    #  if @compliance_policy.update(compliance_policy_params)
    #    PdfWorker.perform_async(@compliance_policy.compliance_policy_docs.order(:id).first.id)
    #    redirect_to business_compliance_policy_path(@compliance_policy)
    #  end
  end

  def edit
    # @annual_review = AnnualReview.find(params[:id])
    render 'new'
  end

  def show
    # @annual_review = AnnualReview.find(params[:id])
    #  @preview_doc = @compliance_policy.compliance_policy_docs.where(id: params[:docid]) if params[:docid]
    #  @preview_doc = if !@preview_doc.nil?
    #                   @preview_doc.first
    #                 else
    #                   @compliance_policy.compliance_policy_docs.first
    #                 end
  end

  private

  def set_review
    @annual_review = AnnualReview.find(params[:id])
  end

  def annual_review_params
    params.require(:annual_review).permit(:file, :year)
  end
end
