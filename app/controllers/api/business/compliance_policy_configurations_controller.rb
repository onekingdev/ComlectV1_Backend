# frozen_string_literal: true

class Api::Business::CompliancePolicyConfigurationsController < ApiController
  before_action :require_business!
  before_action { authorize_action(Roles::CompliancePolicy) }
  before_action { authorize_business_tier(Business::CompliancePolicy) }
  before_action :default_configuration

  def show
    respond_with @cpconf, serializer: CompliancePolicyConfigurationSerializer
  end

  def update
    if @cpconf.update(cpconf_params)
      respond_with @cpconf, serializer: CompliancePolicyConfigurationSerializer
    else
      respond_with errors: @cpconf.errors, status: :unprocessable_entity
    end
  end

  private

  def default_configuration
    @cpconf = current_business.compliance_policy_configuration.presence ||
              CompliancePolicyConfiguration.create_default(current_business.id)
  end

  def cpconf_params
    params.permit(
      :logo,
      :address,
      :phone,
      :email,
      :disclosure,
      :body
    )
  end

  def find_areport
    @areport = current_business.annual_reports.find(params[:id])
  end
end
