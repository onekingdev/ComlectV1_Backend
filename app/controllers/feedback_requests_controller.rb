# frozen_string_literal: true

class FeedbackRequestsController < ApplicationController
  def new; end

  def create
    @feedback = FeedbackRequest.new(feedback_request_params)
    @err = 'Please fill in your email.' if feedback_request_params[:email].empty?
    if verify_recaptcha(model: @feedback)
      @feedback.assign_attributes(ip: request.remote_ip, user_agent: request.user_agent)
      @feedback.save!
    else
      @err = 'Please solve CAPTCHA to proceed.'
    end
    render layout: false
  end

  private

  def feedback_request_params
    params.require(:feedback_request).permit(:name, :email, :phone, :specialists, :budget, :description, :kind)
  end
end
