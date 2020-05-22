# frozen_string_literal: true

class Specialists::AuditRequestsController < ApplicationController
  before_action :require_specialist!
  before_action :set_business

  def index
    @audit_requests = AuditRequest.all.order(:id)
    @audit_docs = @business.audit_docs
    render 'business/audit_requests/index'
  end

  def destroy
    @audit_doc = @business.audit_docs.find(params[:id])
    audit_request_id = @audit_doc.audit_request_id
    @audit_doc.destroy
    redirect_to specialists_business_audit_requests_path(@business.username, "audit_request_id": audit_request_id)
  end

  def update
    @audit_doc = AuditDoc.create(audit_doc_params)
    @audit_doc.update(business_id: @business.id, processed: false)
    redirect_to specialists_business_audit_requests_path(@business.username)
  end

  def show
    @project_template = ProjectTemplate.find_by(identifier: params[:id])
    @project_description = @project_template.public_description.split("\r\n")
  end

  def create
    # template = ProjectTemplate.find_by(identifier: params[:id])
    ## if current_business && current_user.payment_info?
    # @project = Project.new.build_from_template(@business.id, template, {})
    # @project.save!
    # respond_to do |format|
    #  format.json do
    #    render json: { url: business_project_path(@project) }
    #  end
    # end
    ## redirect_to business_project_path(@project)
    ## end
  end

  def new; end

  private

  def audit_doc_params
    params.require(:audit_doc).permit(:file, :audit_request_id)
  end

  def set_business
    @business = current_specialist.manageable_ria_businesses.find_by(username: params[:business_id])
  end
end
