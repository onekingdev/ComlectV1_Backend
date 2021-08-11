# frozen_string_literal: true

class Api::Business::AnnualReportsController < ApiController
  before_action :require_business!
  before_action { authorize_action(Roles::AnnualReportsPolicy) }
  before_action :find_areport, only: %i[show update destroy clone]

  def clone
    new_report = @areport.deep_clone include: %i[
      annual_review_employees
      regulatory_changes
      review_categories
    ]
    new_report.save
    if new_report.errors.any?
      respond_with errors: new_report.errors, status: :unprocessable_entity
    else
      respond_with new_report, serializer: AnnualReportSerializer
    end
  end

  def index
    respond_with current_business.annual_reports, each_serializer: AnnualReportSerializer
  end

  def show
    respond_with @areport, serializer: AnnualReportSerializer
  end

  def create
    areport = current_business.annual_reports.create(areport_params)
    if areport.errors.any?
      respond_with errors: areport.errors, status: :unprocessable_entity
    else
      respond_with areport, serializer: AnnualReportSerializer
    end
  end

  def update
    if @areport.update(areport_params)
      respond_with @areport, serializer: AnnualReportSerializer
    else
      respond_with errors: @areport.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @areport.destroy
      respond_with @areport, serializer: AnnualReportSerializer
    else
      head :bad_request
    end
  end

  private

  def find_areport
    @areport = current_business.annual_reports.find(params[:id])
  end

  def areport_params
    params.require(:annual_report).permit(
      :id,
      :review_start,
      :review_end,
      :year,
      :name,
      :material_business_changes,
      regulatory_changes_attributes: %i[id change],
      annual_review_employees_attributes: %i[id name title department],
      review_categories_attributes: %i[id complete name review_topics]
    )
  end
end
