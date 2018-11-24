# frozen_string_literal: true

class ForumSubscriptionsController < ApplicationController
  # Dumb subscription updater

  def create
    referer = URI(request.referer).path
    lvl = params[:lvl].to_i
    if [1, 2].include? lvl
      if current_business
        current_business.update(qna_lvl: lvl)
        redirect_to referer, notice: 'Subscription confirmed'
      else
        redirect_to referer, notice: 'Please sign up as a business to subscribe'
      end
    else
      redirect_to referer, notice: 'Incorrect options'
    end
  end
end
