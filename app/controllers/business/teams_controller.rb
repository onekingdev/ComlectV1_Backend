# frozen_string_literal: true

class Business::TeamsController < ApplicationController
  before_action :set_team, only: %i[update edit show]
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
    redirect_to business_teams_path if @team.save!
  end

  def update
    redirect_to business_teams_path if @team.update(team_params)
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, team_members_attributes: %i[name title email])
  end
end
