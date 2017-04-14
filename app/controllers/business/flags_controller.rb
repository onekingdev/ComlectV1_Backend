# frozen_string_literal: true
class Business::FlagsController < ApplicationController
  before_action :find_project

  def create
    question = @project.questions.find(flag_params[:question_id])
    @flag = Flag::Create.(current_business, question, flag_params.slice(:reason))
    redirect_to business_project_path(@project)
  end

  private

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end

  def flag_params
    params.require(:flag).permit(:reason, :question_id)
  end
end
