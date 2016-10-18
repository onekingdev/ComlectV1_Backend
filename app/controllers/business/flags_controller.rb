# frozen_string_literal: true
class Business::FlagsController < ApplicationController
  before_action :find_project

  def create
    @flag = Flag.new
    @flag.reason = flag_params[:reason]
    @flag.flagger = current_business
    @flag.flagged_content = @project.questions.find(flag_params[:question_id])
    @flag.save
    redirect_to business_project_dashboard_path(@project)
  end

  private

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end

  def flag_params
    params.require(:flag).permit(:reason, :question_id)
  end
end
