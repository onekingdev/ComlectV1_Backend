# frozen_string_literal: true

class Business::AuditRequestsController < ApplicationController
  before_action :require_business!

  def index
    @audit_requests = AuditRequest.all.order(:id)
    @audit_docs = current_business.audit_docs
  end

  def destroy
    @audit_doc = current_business.audit_docs.find(params[:id])
    audit_request_id = @audit_doc.audit_request_id
    @audit_doc.destroy
    redirect_to business_audit_requests_path("audit_request_id": audit_request_id)
  end

  def update
    @audit_doc = AuditDoc.create(audit_doc_params)
    @audit_doc.update(business_id: current_business.id, processed: false)
    redirect_to business_audit_requests_path
  end

  def create; end

  private

  def audit_doc_params
    params.require(:audit_doc).permit(:file, :audit_request_id)
  end
end
