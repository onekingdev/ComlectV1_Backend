# frozen_string_literal: true

class Api::Specialist::RolesController < ApiController
  before_action :require_specialist!
  skip_before_action :verify_authenticity_token

  def index
    if current_specialist.seat?
      render json: { role: current_specialist.seat_role, business_name: current_specialist.manager.name, business_id: current_specialist.manager.id }.to_json
    else
      roles = current_specialist.specialists_business_roles
      respond_with roles, each_serializer: Specialist::RoleSerializer
    end
  end
end
