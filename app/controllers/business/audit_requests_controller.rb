# frozen_string_literal: true

class Business::AuditRequestsController < ApplicationController
  before_action :require_business!
  before_action :set_mock_audit_template, only: ['index']

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

  def show
    @business = current_business
    @project_template = ProjectTemplate.find_by(identifier: params[:id])
    @project_description = @project_template.public_description.split("\r\n")
  end

  def create
    template = ProjectTemplate.find_by(identifier: params[:id])
    # if current_business && current_user.payment_info?
    @project = Project.new.build_from_template(current_business.id, template, {})
    @project.save!
    respond_to do |format|
      format.json do
        render json: { url: business_project_path(@project) }
      end
    end
    # redirect_to business_project_path(@project)
    # end
  end

  def new
  end
  # def new
  #   @project = Project::Form.copy(project_from_params(params[:id]))
  #   render 'business/projects/new'
  # end

  private

  def project_from_params(params_solution)
    template = ProjectTemplate.find_by(identifier: params_solution)
    Project.new.build_from_template(current_business.id, template, {})
  end

  def set_mock_audit_template
    @mock_audit = if current_business.funds?
                    current_business.total_assets > 500_000_000 ? 'mock_audit_aum_funds' : 'mock_audit_funds'
                  else
                    current_business.total_assets > 500_000_000 ? 'mock_audit_aum' : 'mock_audit'
                  end
  end

  def audit_doc_params
    params.require(:audit_doc).permit(:file, :audit_request_id)
  end
end
