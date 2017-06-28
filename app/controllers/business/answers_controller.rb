# frozen_string_literal: true

class Business::AnswersController < DocumentsController
  before_action :find_project

  def create
    @answer = Answer.new
    @answer.text = answer_params[:text]
    @answer.question = @project.questions.find(answer_params[:question_id])
    @answer.save
    Notification::Deliver.project_answer! @answer
    redirect_to business_project_path(@project)
  end

  private

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end

  def answer_params
    params.require(:answer).permit(:text, :question_id)
  end
end
