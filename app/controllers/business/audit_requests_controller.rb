# frozen_string_literal: true

class Business::AuditRequestsController < ApplicationController
  before_action :require_business!
  before_action :set_mock_audit_template, only: ['index']

  def index
    @audit_requests = AuditRequest.all.order(:id)
    @audit_comments = {}
    @file_folders = current_business.file_folders.root
    @file_docs = current_business.file_docs.root
    current_business.audit_comments.each do |comment|
      @audit_comments[comment.audit_request_id] = comment.body
    end
  end

  def destroy; end

  def update
    params['audit_comments'].each do |k, v|
      if v.present?
        audit_comment = current_business.audit_comments.find_or_create_by(audit_request_id: k.to_i)
        audit_comment.update(body: v)
      end
    end
    render text: 'ok'
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

  def new; end

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
end
