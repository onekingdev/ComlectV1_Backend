# frozen_string_literal: true

class Business::TeamsController < ApplicationController
  before_action :set_team, only: %i[update edit show destroy]
  before_action :require_business!

  def index
    @teams = current_business.teams
    @active_specialists = current_business.active_specialists
  end

  def new
    @team = Team.new
    @team.team_members.build
  end

  def edit
    render 'new'
  end

  def create
    @team = Team.new(team_params)
    @team.business_id = current_business.id
    @team.save ? redirect_to(business_seats_path) : render('new')
  end

  def update
    @team.update(team_params) ? redirect_to(business_seats_path) : render('new')
  end

  def destroy
    @team.destroy

    redirect_to business_seats_path, notice: 'Successfully removed.'
  end

  private

  def set_team
    @team = current_business.teams.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, team_members_attributes: %i[id name title email _destroy])
  end
end
