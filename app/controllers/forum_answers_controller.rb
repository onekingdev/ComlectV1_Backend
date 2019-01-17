# frozen_string_literal: true

class ForumAnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @forum_answer = ForumAnswer.new(forum_answer_params)
    if current_specialist || current_business && current_business.subscription? == 2
      @forum_answer.user_id = current_user.id
      if @forum_answer.save
        @question = @forum_answer.forum_question
        if request.xhr?
          render partial: 'answer', locals: { answer: @forum_answer }
        else
          redirect_to @forum_answer.forum_question
        end
      else
        redirect_to @forum_answer.forum_question
      end
    else
      redirect_to @forum_answer.forum_question, notice: 'Not authorized'
    end
  end

  private

  def forum_answer_params
    params.require(:forum_answer).permit(:body, :reply_to, :forum_question_id, :file)
  end
end
