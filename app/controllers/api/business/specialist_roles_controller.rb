# frozen_string_literal: true

class Api::Business::SpecialistRolesController < ApiController
  def update
    specialist = current_business.active_specialists.find(params[:id])
    if specialist.seat?
      if specialist_params[:role] == 'none'
        specialist.update(seat_role: nil)
        respond_with specialist, serializer: Business::SpecialistSerializer
      elsif specialist.update(seat_role: SpecialistsBusinessRole.roles[specialist_params[:role]])
        respond_with specialist, serializer: Business::SpecialistSerializer
      else
        respond_with errors: specialist.errors, status: :unprocessable_entity
      end
    elsif specialist_params[:role] == 'none'
      role = SpecialistsBusinessRole.find_by(business_id: current_business.id, specialist_id: specialist.id)
      role&.delete
      respond_with status: :ok
    else
      role = SpecialistsBusinessRole.find_or_create_by(business_id: current_business.id, specialist_id: specialist.id)
      if role.update(role: SpecialistsBusinessRole.roles[specialist_params[:role]])
        respond_with role
      else
        respond_with errors: role.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def specialist_params
    params.require(:specialist).permit(:role)
  end
end
