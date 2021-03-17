# frozen_string_literal: true

class Business::CompliancePoliciesController < ApplicationController
    include ActionView::Helpers::TagHelper

  before_action :require_business!
  before_action :set_cpolicy, only: %i[update edit show destroy ban unban]

    def index
      render html: content_tag('business-policies-page', '').html_safe, layout: 'vue_business'
    end

    def new
        @local_project = params[:local_project_id] ? LocalProject.find(params[:local_project_id]) : nil
        render html: content_tag('business-post-project-page',
                                 '',
                                 ':industry-ids': Industry.all.map(&proc { |ind| { id: ind.id, name: ind.name } }).to_json,
                                 ':jurisdiction-ids': Jurisdiction.all.map(&proc { |ind| { id: ind.id, name: ind.name } }).to_json,
                                 ':local-project': @local_project.to_json)
          .html_safe,
           layout: 'vue_business'
    end

  def destroy
    @compliance_policy.destroy
    redirect_to business_compliance_policies_path
  end

  def create
    render html: content_tag('business-policies-create-page', '').html_safe, layout: 'vue_business'
  end

  def update
    if (@compliance_policy.business_id == current_business.id) && @compliance_policy.update(compliance_policy_params)
      if @compliance_policy.compliance_policy_docs.any?
        PdfCompliancePolicyWorker.perform_async(@compliance_policy.compliance_policy_docs.order(:id).first.id)
      end
      redirect_to business_compliance_policy_path(@compliance_policy)
    else
      render 'edit'
    end
  end

  def edit
    @compliance_policy.compliance_policy_docs.build
  end

  def show
    if current_business == @compliance_policy.business
      @preview_doc = @compliance_policy.compliance_policy_docs.where(id: params[:docid]) if params[:docid]
      @preview_doc = if !@preview_doc.nil?
                       @preview_doc.first
                     else
                       @compliance_policy.compliance_policy_docs.first
                     end
      respond_to do |format|
        format.json do
          preview_out = @preview_doc.pdf ? @preview_doc.pdf_url : false
          render json: { "preview": preview_out }
        end
        format.html do
          # poof
        end
      end
    else
      redirect_to '/business'
    end
  end

  def sort
    params[:compliance_policy].each_with_index do |id, index|
      current_business.compliance_policies.where(id: id).update_all(position: index + 1)
    end
    PdfCompliancePolicyWorker.perform_async(current_business.compliance_policies.first.compliance_policy_docs.order(:id).first.id)
    @preview_doc = current_business.compliance_policies.first
    respond_to do |format|
      format.js
    end
  end

  def ban
    @compliance_policy.update(ban: true)
    PdfCompliancePolicyWorker.perform_async(@compliance_policy.compliance_policy_docs.order(:id).first.id)
    respond_to do |format|
      format.html do
        redirect_to business_compliance_policies_path
      end
    end
  end

  def unban
    @compliance_policy.update(ban: false)
    PdfCompliancePolicyWorker.perform_async(@compliance_policy.compliance_policy_docs.order(:id).first.id)
    respond_to do |format|
      format.html do
        redirect_to business_compliance_policies_path
      end
    end
  end

  private

  def set_cpolicy
    @business = current_business
    @compliance_policy = current_business.compliance_policies.find(params[:id])
  end

  def compliance_policy_params
    params.require(:compliance_policy).permit(:title, :section, compliance_policy_docs_attributes: [:doc])
  end
end
