# frozen_string_literal: true

class Api::Business::ReviewCategoriesController < ApiController
  before_action :require_business!
  before_action :find_areport

  def index
    respond_with @areport.review_categories, each_serializer: ReviewCategorySerializer
  end

  def create
    category = @areport.review_categories.create(category_params)
    if category.errors.any?
      respond_with errors: category.errors, status: :unprocessable_entity
    else
      respond_with category, serializer: ReviewCategorySerializer
    end
  end

  def update
    category = @areport.review_categories.find(params[:id])
    if category.update(category_params)
      respond_with category, serializer: ReviewCategorySerializer
    else
      respond_with errors: category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    category = @areport.review_categories.find(params[:id])
    if category.destroy
      respond_with category, serializer: ReviewCategorySerializer
    else
      head :bad_request
    end
  end

  private

  def category_params
    params.require(:review_category).permit(
      :id,
      :name,
      :complete,
      review_topics: [
        :name, items: [
          :body,
          :checked,
          findings: []
        ]
      ]
    )
  end

  def find_areport
    @areport = current_business.annual_reports.find(params[:report_id])
  end
end
