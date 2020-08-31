# frozen_string_literal: true

class Business::TeamMembersController < ApplicationController
  def new
    @team_member = TeamMember.new
  end

  def create
    @team_member = TeamMember.create(member_params)

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

  def edit
    @team_member = TeamMember.find_by(id: params[:id])
  end

  def update
    @team_member = TeamMember.find_by(id: params[:id])
    respond_to do |format|
      format.js do
        if @team_member.update(member_params)
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

  def member_params
    params.require(:team_member)
          .permit(:first_name, :last_name, :title, :team_id, :email, :start_date, :end_date, :termination_reason)
  end
end
