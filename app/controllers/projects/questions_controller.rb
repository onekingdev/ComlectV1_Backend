# frozen_string_literal: true

class Projects::QuestionsController < ApplicationController
  before_action :find_project

  def create
    @question = Question.new(question_params.merge(project: @project, specialist: current_specialist))

    if @question.save
      Notification::Deliver.project_question! @question
      redirect_to project_path(@project)
    else
      redirect_to :back, notice: 'Invalid question'
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def question_params
    params.require(:question).permit(:text)
  end
end
