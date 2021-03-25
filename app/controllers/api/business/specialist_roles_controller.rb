# frozen_string_literal: true

class Api::Business::SpecialistRolesController < ApiController
  def update
    specialist = current_business.active_specialists.find(params[:id])
    if specialist.seat?
      specialist.update(seat_role: Specialist.seat_roles[specialist_params[:role]])
    else
      business_specialist_role = specialist.business_specialists_roles.find_by(
        business_id: current_business.id, specialist_id: specialist.id
      )
      business_specialist_role.update(role: BusinessSpecialistsRole.roles[specialist_params[:role]])
    end
    respond_with specialist, serializer: Business::SpecialistSerializer
  end

  private

  def specialist_params
    params.require(:specialist).permit(:role)
  end
end
