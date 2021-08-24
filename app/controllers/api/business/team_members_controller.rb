# frozen_string_literal: true

class Api::Business::TeamMembersController < ApiController
  before_action :require_business!
  before_action :load_team_member, only: :destroy

  def index
    team_members = current_business.team_members
    respond_with team_members, each_serializer: ::TeamMemberSerializer
  end

  def create
    service = BusinessServices::TeamMemberService.call(current_business, member_params)

    if service.success?
      respond_with(service.team_member, serializer: TeamMemberSerializer) and return
    end

    if service.team_member.present?
      respond_with service.team_member
    else
      render json: { error: service.error }, status: :unprocessable_entity
    end
  end

  def update
    service = BusinessServices::TeamMemberService.call(
      current_business,
      member_params,
      load_team_member
    )

    if service.success?
      respond_with service.team_member, serializer: TeamMemberSerializer
    else
      respond_with service.team_member
    end
  end

  def destroy
    @team_member.destroy
    respond_with @team_member, serializer: TeamMemberSerializer
  end

  def specialists
    specialists = current_business.team.specialists
    respond_with specialists, each_serializer: Business::SpecialistSerializer
  end

  private

  def member_params
    params.require(:team_member).permit(
      :first_name, :last_name, :email,
      :role, :start_date, :access_person
    )
  end

  def load_team_member
    @team_member = current_business.team_members.find(params[:id])
  end
end
