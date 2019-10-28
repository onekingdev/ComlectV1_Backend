# frozen_string_literal: true

class Business::CompliancePoliciesController < ApplicationController
  before_action :set_cpolicy, only: %i[update edit show]

  def new
    @compliance_policy = CompliancePolicy.new
    @compliance_policy.compliance_policy_docs.build
  end

  def create
    @compliance_policy = CompliancePolicy.new(compliance_policy_params)
    @compliance_policy.business_id = current_business.id
    redirect_to business_compliance_policy_path(@compliance_policy) if @compliance_policy.save
  end

  def update
    redirect_to business_compliance_policy_path(@compliance_policy) if @compliance_policy.update(compliance_policy_params)
  end

  def edit; end

  def show; end

  private

  def set_cpolicy
    @compliance_policy = CompliancePolicy.find(params[:id])
  end

  def compliance_policy_params
    params.require(:compliance_policy).permit(:title, compliance_policy_docs_attributes: [:doc])
  end
end
