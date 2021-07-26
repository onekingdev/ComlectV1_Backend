# frozen_string_literal: true

class FlagsController < ApplicationController
  before_action :authenticate_user!

  def new
    respond_to do |format|
      format.html { render partial: 'business/flags/new' }
      format.js { render file: 'business/flags/new.js.erb' }
    end
  end

  def create
    flagged_forum_answer = ForumAnswer.find(flag_params[:forum_answer_id])
    @flag = Flag::Create.call(
      current_user.specialist ? current_specialist : current_business,
      flagged_forum_answer,
      reason: flag_params[:reason].values.join(', ')
    )
    redirect_to flagged_forum_answer.forum_question, notice: 'Reported successfully'
  end

  private

  def flag_params
    params.require(:flag).permit(:forum_answer_id, reason: %i[i h s])
  end
end
