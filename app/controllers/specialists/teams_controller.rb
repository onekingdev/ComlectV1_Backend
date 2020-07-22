# frozen_string_literal: true

class Specialists::TeamsController < ApplicationController
  before_action :require_specialist!

  def show
    @specialist = current_specialist
    @team = @specialist.managed_team
    @team = Specialist::Team.create(manager_id: @specialist.id, name: 'Employees') if @team.blank?
    @employees = @team.employees
    @invitations = @team.invitations.pending
  end

  def new
    @team = current_specialist.build_team
  end

  def create
    @specialist = current_specialist
    @team = @specialist.build_team(permitted_params.merge(manager: @specialist))

    if @team.save
      redirect_to specialists_settings_team_path
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:specialist_team).permit(:name)
  end
end
