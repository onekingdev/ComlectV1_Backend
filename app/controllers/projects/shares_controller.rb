# frozen_string_literal: true
class Projects::SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project

  def new
    @share = Project::Share.for(@project, user: current_user)
  end

  def create
    @share = Project::Share.for(@project, share_params)
    if @share.valid?
      @share.send!
    else
      render :new
    end
  end

  private

  def share_params
    params.require(:project_share).permit(:name, :email, :message).merge(user: current_user)
  end

  def find_project
    @project = Project.pending.find(params[:project_id])
  end
end
