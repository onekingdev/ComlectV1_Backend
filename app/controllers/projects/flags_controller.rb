# frozen_string_literal: true
class Projects::FlagsController < ApplicationController
  before_action :find_project

  def create
    @flag = Flag.new
    @flag.reason = flag_params[:reason]
    @flag.flagger = current_specialist
    @flag.flagged_content = find_flagged_content
    @flag.save
    redirect_to project_path(@project)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def flag_params
    params.require(:flag).permit(:reason, :answer_id, :question_id)
  end

  def find_flagged_content
    if flag_params[:question_id].present?
      Question.find(flag_params[:question_id])
    elsif flag_params[:answer_id].present?
      Answer.find(flag_params[:answer_id])
    end
  end
end
