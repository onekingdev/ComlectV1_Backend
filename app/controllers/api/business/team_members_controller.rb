# frozen_string_literal: true

class Api::Business::TeamMembersController < ApiController
  before_action :require_business!

  def index
    team_ids = current_business.teams.ids
    team_members = TeamMember.where(team_id: team_ids)

    respond_with team_members, each_serializer: ::TeamMemberSerializer
  end

  def create
    service = BusinessServices::TeamMemberService.call(current_business, member_params)

    if service.success?
      respond_with(service.team_member, serializer: ::TeamMemberSerializer) and return
    end

    if service.team_member.present?
      respond_with service.team_member
    else
      render json: { error: service.error }, status: :unprocessable_entity
    end
  end

  private

  def member_params
    params.require(:team_member).permit(
      :first_name, :last_name, :email,
      :role, :start_date, :access_person
    )
  end
end
