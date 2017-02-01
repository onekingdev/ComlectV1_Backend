# frozen_string_literal: true
class Projects::QuestionsController < ApplicationController
  before_action :find_project

  def create
    @question = Question.create(question_params.merge(project: @project, specialist: current_specialist))
    redirect_to project_path(@project)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def question_params
    params.require(:question).permit(:text)
  end
end
