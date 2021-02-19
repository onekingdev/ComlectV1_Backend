# frozen_string_literal: true

class Business::TeamMembersController < ApplicationController
  before_action :set_team_member, only: %i[update edit destroy]
  before_action :require_business!

  def new
    @team_member = TeamMember.new
  end

  def create
    current_business.assign_team(@team_member) unless @team_member.team
    respond_to do |format|
      format.js do
        if @team_member.valid?
          render 'business/team_members/reload'
        else
          render 'business/team_members/errors', locals: { errors: @team_member.errors.full_messages }
        end
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      format.js do
        if @team_member.update(member_params)
          current_business.assign_team(@team_member) unless @team_member.team
          render 'business/team_members/reload'
        else
          render 'business/team_members/errors', locals: { errors: @team_member.errors.full_messages }
        end
      end
    end
  end

  def destroy
    TeamMember.destroy(params[:id])

    redirect_to business_seats_path, notice: 'Successfully removed.'
  end

  private

  def set_team_member
    vulnerable_member = TeamMember.find(params[:id])
    @team_member = vulnerable_member if vulnerable_member.team.business_id == current_business.id
  end

  def member_params
    params.require(:team_member)
          .permit(:first_name, :last_name, :title, :team_id, :access_person, :email, :start_date, :end_date, :termination_reason)
  end
end
