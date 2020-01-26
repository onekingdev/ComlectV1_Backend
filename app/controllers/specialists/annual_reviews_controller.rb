# frozen_string_literal: true

class Specialists::AnnualReviewsController < ApplicationController
  before_action :require_specialist!
  before_action :set_business
  before_action :set_review, only: %i[update edit show]

  def index
    avail_prices = [[1500, 2000, 2500], [2000, 2500, 3000]]
    @prices = @business.employees_cnt > 10 ? avail_prices[1] : avail_prices[0]
    render 'business/annual_reviews/index'
  end

  def new
    @annual_review = AnnualReview.new
    render 'business/annual_reviews/new'
  end

  def create
    @annual_review = AnnualReview.new(annual_review_params)
    @annual_review.business_id = @business.id
    if @annual_review.save
      PdfReviewWorker.perform_async(@annual_review.id)
      redirect_to specialists_business_annual_review_path(@business.username, @annual_review)
    else
      render 'business/annual_reviews/new'
    end
  end

  def update
    if @annual_review.update(annual_review_params)
      if annual_review_params['file'].present?
        @annual_review.update(processed: false)
        PdfReviewWorker.perform_async(@annual_review.id)
      end
      redirect_to specialists_business_annual_review_path(@business.username, @annual_review)
    else
      render 'business/annual_reviews/new'
    end
  end

  def edit
    render 'business/annual_reviews/new'
  end

  def show
    if @business == @annual_review.business
      respond_to do |format|
        format.json do
          preview_out = @annual_review.pdf && @annual_review.processed ? @annual_review.pdf_url : false
          render json: { "preview": preview_out }
        end
        format.html do
          render 'business/annual_reviews/show'
          # poof
        end
        format.js do
          render 'business/annual_reviews/show'
        end
      end
    else
      redirect_to specialists_business_path(@business.username)
    end
  end

  private

  def set_review
    @annual_review = @business.annual_reviews.find(params[:id])
  end

  def annual_review_params
    params.require(:annual_review).permit(:file, :year)
  end

  def set_business
    @business = current_specialist.manageable_ria_businesses.find_by(username: params[:business_id])
  end
end
