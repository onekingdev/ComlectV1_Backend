# frozen_string_literal: true

class Specialists::AuditRequestsController < ApplicationController
  before_action :require_specialist!
  before_action :set_business

  def index
    @audit_requests = AuditRequest.all.order(:id)
    @audit_docs = @business.audit_docs
    render 'business/audit_requests/index'
  end

  def new
    @audit_request = AuditRequest.find(params[:request])
    @audit_doc = @business.audit_docs.where(audit_request_id: @audit_request.id)
    @audit_doc = if @audit_doc.any?
                   @audit_doc.first
                 else
                   AuditDoc.new(audit_request_id: @audit_request.id)
                 end
    render 'business/audit_requests/new'
  end

  def edit
    @audit_request = AuditRequest.find(params[:id])
    @audit_doc = @business.audit_docs.where(audit_request_id: @audit_request.id)
    @audit_doc = if @audit_doc.any?
                   @audit_doc.first
                 else
                   AuditDoc.new(audit_request_id: @audit_request.id)
                 end
    render 'business/audit_requests/edit'
  end

  def show
    @audit_request = AuditRequest.find(params[:id])
    @audit_doc = @business.audit_docs.where(audit_request_id: @audit_request.id)
    if @audit_doc.any?
      @audit_doc = @audit_doc.first
      respond_to do |format|
        format.json do
          preview_out = @audit_doc.pdf && @audit_doc.processed ? @audit_doc.pdf_url : false
          render json: { "preview": preview_out }
        end
        format.html do
          render 'business/audit_requests/show'
          # poof
        end
        format.js do
          render 'business/audit_requests/show'
        end
      end
    else
      redirect_to specialists_business_audit_requests_path(@business.username)
    end
  end

  def update
    @audit_doc = @business.audit_docs.where(audit_request_id: audit_doc_params['audit_request_id'])
    if @audit_doc.any?
      @audit_doc = @audit_doc.first
      @audit_doc.update(audit_doc_params)
      @audit_doc.update(processed: false)
    else
      @audit_doc = AuditDoc.create(audit_doc_params)
      @audit_doc.update(business_id: @business.id, processed: false)
    end
    PdfAuditWorker.perform_async(@audit_doc.id)
    redirect_to specialists_business_audit_requests_path(@business.username)
  end

  def create; end

  private

  def audit_doc_params
    params.require(:audit_doc).permit(:file, :audit_request_id)
  end

  def set_business
    @business = current_specialist.manageable_ria_businesses.find_by(username: params[:business_id])
  end
end
