# frozen_string_literal: true
class Projects::FlagsController < ApplicationController
  before_action :find_project

  def create
    @flag = Flag.new
    @flag.reason = flag_params[:reason]
    @flag.flagger = current_specialist
    @flag.flagged_content = @project.answers.find(flag_params[:answer_id])
    @flag.save
    redirect_to project_dashboard_path(@project)
  end

  private

  def find_project
    @project = current_specialist.projects.find(params[:project_id])
  end

  def flag_params
    params.require(:flag).permit(:reason, :answer_id)
  end
end
