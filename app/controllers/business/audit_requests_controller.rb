# frozen_string_literal: true

class Business::AuditRequestsController < ApplicationController
  def index
    @audit_requests = AuditRequest.all.order(:id)
    @audit_docs = current_business.audit_docs
  end

  def new
    @audit_request = AuditRequest.find(params[:request])
    @audit_doc = current_business.audit_docs.where(audit_request_id: @audit_request.id)
    @audit_doc = if @audit_doc.any?
                   @audit_doc.first
                 else
                   AuditDoc.new(audit_request_id: @audit_request.id)
                 end
  end

  def edit
    @audit_request = AuditRequest.find(params[:id])
    @audit_doc = current_business.audit_docs.where(audit_request_id: @audit_request.id)
    @audit_doc = if @audit_doc.any?
                   @audit_doc.first
                 else
                   AuditDoc.new(audit_request_id: @audit_request.id)
                 end
  end

  def show
    @audit_request = AuditRequest.find(params[:id])
    @audit_doc = current_business.audit_docs.where(audit_request_id: @audit_request.id)
    if @audit_doc.any?
      @audit_doc = @audit_doc.first
      respond_to do |format|
        format.json do
          preview_out = @audit_doc.pdf && @audit_doc.processed ? @audit_doc.pdf_url : false
          render json: { "preview": preview_out }
        end
        format.html do
          # poof
        end
      end
    else
      redirect_to business_audit_requests_path
    end
  end

  def update
    @audit_doc = current_business.audit_docs.where(audit_request_id: audit_doc_params['audit_request_id'])
    if @audit_doc.any?
      @audit_doc = @audit_doc.first
      @audit_doc.update(audit_doc_params)
      @audit_doc.update(processed: false)
    else
      @audit_doc = AuditDoc.create(audit_doc_params)
      @audit_doc.update(business_id: current_business.id, processed: false)
    end
    PdfAuditWorker.perform_async(@audit_doc.id)
    redirect_to business_audit_requests_path
  end

  def create; end

  private

  def audit_doc_params
    params.require(:audit_doc).permit(:file, :audit_request_id)
  end
end
