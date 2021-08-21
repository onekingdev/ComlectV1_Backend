# frozen_string_literal: true

class Api::Business::AnnualReportDocumentsController < ApiController
  before_action :require_business!
  before_action :find_annual_report

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    respond_with @annual_report.documents.where.not(file_data: nil), each_serializer: DocumentSerializer
  end

  def create
    document = @annual_report.documents.create(document_params.merge(owner: current_business, uploadable: @annual_report))
    respond_with document, serializer: DocumentSerializer
  end

  def destroy
    document = @annual_report.documents.find(params[:id])
    if document.owner == current_business
      if document.destroy
        respond_with document, serializer: DocumentSerializer
      else
        render json: { error: t('api.documents.cannot_destroy') }, status: :unprocessable_entity
      end
    else
      render json: { error: t('api.documents.not_owner') }, status: :unprocessable_entity
    end
  end

  private

  def find_annual_report
    @annual_report = current_business.annual_reports.find(params[:annual_report_id])
  end

  def document_params
    params.permit(:file)
  end
end
