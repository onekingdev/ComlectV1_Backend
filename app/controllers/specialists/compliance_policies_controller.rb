# frozen_string_literal: true

class Specialists::CompliancePoliciesController < ApplicationController
  before_action :require_specialist!
  before_action :set_business
  before_action :set_cpolicy, only: %i[update edit show destroy]

  def new
    @compliance_policy = CompliancePolicy.new
    @compliance_policy.compliance_policy_docs.build
    @compliance_policy.title = params[:title] if params[:title].present?
    render 'business/compliance_policies/new'
  end

  # rubocop:disable Metrics/AbcSize
  def index
    @preview_doc = @business.compliance_policies.first
    respond_to do |format|
      format.json do
        if @preview_doc.blank? || @preview_doc.pdf_data.nil?
          render json: { "preview": specialists_business_compliance_policies_path(@business.username, format: :pdf) }
        else
          preview_out = @preview_doc.pdf ? @preview_doc.pdf_url : false
          # rubocop:disable Metrics/LineLength
          render json: { "preview": preview_out, "business_name": @business.business_name, "email": "mailto:?body=Please find our Compliance Manual attached %0D%0A%0D%0ADownload: #{Rails.env.production? ? url_for(@preview_doc.pdf_url) : root_url.delete_suffix('/') + url_for(@preview_doc.pdf_url)}&subject=#{@business.business_name} Compliance Manual" }
          # rubocop:enable Metrics/LineLength
        end
      end
      format.html do
        render 'business/compliance_policies/index'
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
  # rubocop:enable Metrics/AbcSize

  def destroy
    @compliance_policy.destroy
    redirect_to specialists_business_compliance_policies_path(@business.username)
  end

  def create
    @compliance_policy = CompliancePolicy.new(compliance_policy_params)
    @compliance_policy.business_id = @business.id
    if @compliance_policy.save
      PdfCompliancePolicyWorker.perform_async(@compliance_policy.compliance_policy_docs.order(:id).first.id)
      redirect_to specialists_business_compliance_policy_path(@business.username, @compliance_policy)
    else
      @compliance_policy.compliance_policy_docs.build
      render 'business/compliance_policies/new'
    end
  end

  def update
    if (@compliance_policy.business_id == @business.id) && @compliance_policy.update(compliance_policy_params)
      PdfCompliancePolicyWorker.perform_async(@compliance_policy.compliance_policy_docs.order(:id).first.id)
      redirect_to specialists_business_compliance_policy_path(@business.username, @compliance_policy)
    else
      render 'business/compliance_policies/edit'
    end
  end

  def edit
    @compliance_policy.compliance_policy_docs.build
    render 'business/compliance_policies/new'
  end

  def show
    if @business == @compliance_policy.business
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
          render 'business/compliance_policies/show'
        end
        format.js do
          render 'business/compliance_policies/show'
        end
      end
    else
      redirect_to specialists_business_path(@business.username)
    end
  end

  private

  def set_cpolicy
    @compliance_policy = @business.compliance_policies.find(params[:id])
  end

  def compliance_policy_params
    params.require(:compliance_policy).permit(:title, :section, compliance_policy_docs_attributes: [:doc])
  end

  def set_business
    @business = current_specialist.manageable_ria_businesses.find_by(username: params[:business_id])
  end
end
