# frozen_string_literal: true

class ForumAnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @forum_answer = ForumAnswer.new(forum_answer_params)
    @forum_answer.user_id = current_user.id
    if @forum_answer.save
      render partial: 'answer', locals: { answer: @forum_answer }
    else
      redirect_to @forum_answer.forum_question
    end
  end

  private

  def forum_answer_params
    params.require(:forum_answer).permit(:body, :reply_to, :forum_question_id)
  end
end
