# frozen_string_literal: true

class Api::Specialist::RolesController < ApiController
  before_action :require_specialist!
  skip_before_action :verify_authenticity_token

  def index
    if current_specialist.seat?
      respond_with current_specialist, serializer: Business::SpecialistSerializer
    else
      roles = current_specialist.specialists_business_roles
      respond_with specialist_business_roles: roles
    end
  end
end
