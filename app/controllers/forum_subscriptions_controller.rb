# frozen_string_literal: true

class ForumSubscriptionsController < ApplicationController
  # Dumb subscription updater

  def create
    referer = URI(request.referer).path
    lvl = params[:lvl].to_i
    if [1, 2].include? lvl
      if current_business && current_business.payment_sources.any?
        current_business.update(qna_lvl: lvl)
        redirect_to referer, notice: 'Subscription confirmed'
      else
        redirect_to referer, notice: 'Please submit a payment option to proceed'
      end
    else
      redirect_to referer, notice: 'Incorrect options'
    end
  end
end
