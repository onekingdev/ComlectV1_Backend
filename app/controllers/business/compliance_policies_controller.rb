# frozen_string_literal: true

class Business::CompliancePoliciesController < ApplicationController
  before_action :require_business!
  before_action :set_cpolicy, only: %i[update edit show destroy]

  def index
    @business = current_business
    @preview_doc = @business.compliance_policies.first
    respond_to do |format|
      format.json do
        if @preview_doc.blank?
          render json: { "preview": business_compliance_policies_path(format: :pdf) }
        elsif @preview_doc.pdf_data.nil?
          render json: { "preview": false }
        else
          preview_out = @preview_doc.pdf ? @preview_doc.pdf_url : false
          # rubocop:disable Metrics/LineLength
          render json: { "preview": preview_out, "business_name": @business.business_name, "email": "mailto:?body=Please find our Compliance Manual attached %0D%0A%0D%0ADownload: #{Rails.env.production? ? url_for(@preview_doc.pdf_url) : root_url.delete_suffix('/') + url_for(@preview_doc.pdf_url)}&subject=#{@business.business_name} Compliance Manual" }
          # rubocop:enable Metrics/LineLength
        end
      end
      format.html do
        # poof
      end
      format.pdf do
        render pdf: 'compliance_manual.pdf',
               template: 'business/compliance_policies/header.pdf.erb', encoding: 'UTF-8',
               locals: { last_updated: Time.zone.today, business: @business },
               margin: { top:               20,
                         bottom:            25,
                         left:              15,
                         right:             15 }
      end
    end
  end

  def destroy
    @compliance_policy.destroy
    redirect_to business_compliance_policies_path
  end

  def new
    @business = current_business
    @compliance_policy = CompliancePolicy.new
    @compliance_policy.compliance_policy_docs.build
    @compliance_policy.title = params[:title] if params[:title].present?
    @compliance_policy.section = params[:section_id] if params[:section_id].present?
  end

  def create
    @business = current_business
    @compliance_policy = CompliancePolicy.new(compliance_policy_params)
    @compliance_policy.business_id = current_business.id
    if @compliance_policy.save
      if @compliance_policy.compliance_policy_docs.any?
        PdfCompliancePolicyWorker.perform_async(@compliance_policy.compliance_policy_docs.order(:id).first.id)
      end
      redirect_to business_compliance_policy_path(@compliance_policy)
    else
      @compliance_policy.compliance_policy_docs.build
      render 'new'
    end
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

  private

  def set_cpolicy
    @business = current_business
    @compliance_policy = current_business.compliance_policies.find(params[:id])
  end

  def compliance_policy_params
    params.require(:compliance_policy).permit(:title, :section, compliance_policy_docs_attributes: [:doc])
  end
end
