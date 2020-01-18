# frozen_string_literal: true

class Business::CompliancePoliciesController < ApplicationController
  before_action :set_cpolicy, only: %i[update edit show]
  before_action :require_business!

  def new
    @compliance_policy = CompliancePolicy.new
    @compliance_policy.compliance_policy_docs.build
  end

  def create
    @compliance_policy = CompliancePolicy.new(compliance_policy_params)
    @compliance_policy.business_id = current_business.id
    if @compliance_policy.save
      PdfWorker.perform_async(@compliance_policy.compliance_policy_docs.order(:id).first.id)
      redirect_to business_compliance_policy_path(@compliance_policy)
    else
      @compliance_policy.compliance_policy_docs.build
      render 'new'
    end
  end

  def update
    # rubocop:disable Style/GuardClause
    if (@compliance_policy.business_id == current_business.id) && @compliance_policy.update(compliance_policy_params)
      PdfWorker.perform_async(@compliance_policy.compliance_policy_docs.order(:id).first.id)
      redirect_to business_compliance_policy_path(@compliance_policy)
    end
    # rubocop:enable Style/GuardClause
  end

  def edit; end

  def show
    if current_business == @compliance_policy.business
      @business = @compliance_policy.business
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

  private

  def set_cpolicy
    @compliance_policy = CompliancePolicy.find(params[:id])
  end

  def compliance_policy_params
    params.require(:compliance_policy).permit(:title, :section, compliance_policy_docs_attributes: [:doc])
  end
end
