# frozen_string_literal: true

class Api::Business::AnnualReportsController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :require_business!
  before_action { authorize_action(Roles::AnnualReportsPolicy) }
  before_action { authorize_business_tier(Business::AnnualReportsPolicy) }
  before_action :find_areport, only: %i[show update destroy clone download]

  def clone
    new_report = @areport.deep_clone include: %i[review_categories]
    new_report.review_categories&.each do |category|
      category.complete = false
      category.review_topics&.each_with_index do |topic, topic_index|
        topic['items']&.each_with_index do |_item, item_index|
          category.review_topics[topic_index]['items'][item_index]['findings'] = []
        end
      end
    end
    new_report.material_business_changes = ''
    new_report.complete = false
    new_report.completed_at = nil
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
    respond_with @areport, serializer: AnnualReportWRemindersSerializer
  end

  def create
    areport = current_business.annual_reports.create(areport_params)
    if areport.errors.any?
      render json: { errors: areport.errors }, status: :unprocessable_entity
    else
      respond_with areport, serializer: AnnualReportSerializer
    end
  end

  def update
    if @areport.update(areport_params)
      @areport.update_attribute('completed_at', Time.zone.now.in_time_zone(@areport.business.time_zone)) if areport_params['complete'] == true
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

  def download
    PdfAnnualReportWorker.perform_async(@areport.id)
    respond_with status: :ok
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
      :complete,
      :year,
      :name,
      :material_business_changes,
      regulatory_changes_attributes: %i[id change response _destroy],
      annual_review_employees_attributes: %i[id name title department _destroy],
      review_categories_attributes: %i[id complete name review_topics]
    )
  end
end
