# frozen_string_literal: true

class ForumAnswersController < ApplicationController
  before_action :authenticate_user!

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/BlockNesting
  def create
    @forum_answer = ForumAnswer.new(forum_answer_params)
    if current_specialist || current_business && current_business.subscription? == 2
      @forum_answer.user_id = current_user.id
      if @forum_answer.save
        if @forum_answer.reply_to.present?
          replied_to = ForumAnswer.find(@forum_answer.reply_to)
          Notification::Deliver.forum_comment!(replied_to) if replied_to.user != current_user
        end
        @question = @forum_answer.forum_question
        @question.update(last_activity: Time.zone.now)
        if request.xhr?
          render partial: 'answer', locals: { answer: @forum_answer }
        else
          redirect_to forum_question_path(@forum_answer.forum_question.url)
        end
        Notification::Deliver.forum_answer!(@forum_answer) unless current_business && @question.business == current_business
      else
        redirect_to forum_question_path(@forum_answer.forum_question.url)
      end
    else
      redirect_to forum_question_path(@forum_answer.forum_question.url), notice: 'Not authorized'
    end
  end
  # rubocop:enable Metrics/BlockNesting
  # rubocop:enable Metrics/AbcSize

  private

  def forum_answer_params
    params.require(:forum_answer).permit(:body, :reply_to, :forum_question_id, :file)
  end
end
