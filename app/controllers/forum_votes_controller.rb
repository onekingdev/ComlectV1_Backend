# frozen_string_literal: true

class ForumVotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_forum_answer

  def upvote
    @existing = @forum_answer.forum_votes.where(user_id: current_user.id)
    if @existing.count.positive?
      @existing = @existing.first
      if @existing.upvote
        @existing.destroy
      else
        @existing.update(upvote: true)
        @existing.user.specialist&.calc_forum_upvotes
      end
    else
      ForumVote.create(forum_answer_id: params[:id], user_id: current_user.id, upvote: true)
    end
    @forum_answer.update_upvotes_cnt
    render partial: 'forum_answers/forum_buttons', locals: { answer: @forum_answer }
  end

  def downvote
    @existing = ForumVote.where(forum_answer_id: params[:id], user_id: current_user.id)
    if @existing.count.positive?
      @existing = @existing.first
      if @existing.upvote
        @existing.update(upvote: false)
      else
        @existing.destroy
      end
    else
      ForumVote.create(forum_answer_id: params[:id], user_id: current_user.id, upvote: false)
    end
    @forum_answer.update_upvotes_cnt
    render partial: 'forum_answers/forum_buttons', locals: { answer: @forum_answer }
  end

  private

  def set_forum_answer
    @forum_answer = ForumAnswer.find(params[:id])
    @existing = @forum_answer.forum_votes.where(user_id: current_user.id)
  end
end
