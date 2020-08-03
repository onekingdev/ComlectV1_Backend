# frozen_string_literal: true

class Specialists::InvitationsController < ApplicationController
  before_action :require_specialist!

  def create
    @specialist = current_specialist
    @team = @specialist.managed_team
    @invitation = @team.invitations.new(permitted_params)

    if @invitation.save
      flash[:notice] = 'Invitation sent'
      Notification::Deliver.got_employee_invitation!(@invitation)
    end

    redirect_to specialists_settings_team_path
  end

  def destroy
    @specialist = current_specialist
    @team = @specialist.managed_team || @specialist.team
    @invitation = @team.invitations.find(params[:id])

    authorize @invitation, :destroy?
    flash[:notice] = 'Invitation deleted' if @invitation.destroy
    redirect_to specialists_settings_team_path, status: :see_other
  end

  private

  def permitted_params
    params.require(:specialist_invitation).permit(:first_name, :last_name, :email)
  end
end
