# frozen_string_literal: true

class Api::Business::RisksController < ApiController
  before_action :require_business!
  before_action :find_risk, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    respond_with current_business.risks,
                 each_serializer: RiskSerializer
  end

  def show
    respond_with @risk, serializer: RiskSerializer
  end

  def destroy
    if @risk.destroy
      respond_with @risk, serializer: RiskSerializer
    else
      head :bad_request
    end
  end

  def create
    risk = current_business.risks.create(risk_params)
    if risk.errors.any?
      respond_with errors: risk.errors, status: :unprocessable_entity
    else
      respond_with risk, serializer: RiskSerializer
    end
  end

  def update
    if @risk.update(risk_params)
      respond_with @risk, serializer: RiskSerializer
    else
      respond_with errors: @risk.errors, status: :unprocessable_entity
    end
  end

  private

  def find_risk
    @risk = current_business.risks.find(params[:id])
  end

  def risk_params
    params.permit(
      :name,
      :impact,
      :likelihood,
      compliance_policy_ids: []
    )
  end
end
