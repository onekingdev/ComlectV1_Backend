# frozen_string_literal: true

class Api::Business::TeamMembersController < ApiController
  before_action :require_business!

  def create
    team_member = TeamMember.new(member_params)
    current_business.assign_team(team_member)

    if team_member.save
      respond_with team_member, serializer: ::TeamMemberSerializer
    else
      respond_with team_member
    end
  end

  private

  def member_params
    params.require(:team_member).permit(
      :first_name, :last_name, :email,
      :start_date, :access_person
    )
  end
end
