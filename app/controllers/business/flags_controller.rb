# frozen_string_literal: true

class Business::FlagsController < ApplicationController
  before_action :find_project

  def new; end

  def create
    @flag = Flag::Create.(
      current_business,
      find_flagged_content,
      reason: flag_params[:reason].values.join(', ')
    )

    redirect_to business_project_path(@project)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def flag_params
    params.require(:flag).permit(:question_id, :answer_id, reason: %i[i h s])
  end

  def find_flagged_content
    if flag_params[:question_id].present?
      Question.find(flag_params[:question_id])
    elsif flag_params[:answer_id].present?
      Answer.find(flag_params[:answer_id])
    end
  end
end
