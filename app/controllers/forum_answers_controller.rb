# frozen_string_literal: true

class ForumAnswersController < ApplicationController
  before_action :authenticate_user!

  # rubocop:disable Metrics/AbcSize
  def create
    @forum_answer = ForumAnswer.new(forum_answer_params)
    if current_specialist || current_business && current_business.subscription? == 2
      @forum_answer.user_id = current_user.id
      if @forum_answer.save
        Notification::Deliver.forum_comment!(ForumAnswer.find(@forum_answer.reply_to)) if @forum_answer.reply_to.present?
        @question = @forum_answer.forum_question
        @question.update(last_activity: Time.zone.now)
        if request.xhr?
          render partial: 'answer', locals: { answer: @forum_answer }
        else
          redirect_to forum_question_path(@forum_answer.forum_question.url)
        end
        Notification::Deliver.forum_answer!(@forum_answer)
      else
        redirect_to forum_question_path(@forum_answer.forum_question.url)
      end
    else
      redirect_to forum_question_path(@forum_answer.forum_question.url), notice: 'Not authorized'
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def forum_answer_params
    params.require(:forum_answer).permit(:body, :reply_to, :forum_question_id, :file)
  end
end
