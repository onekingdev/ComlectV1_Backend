# frozen_string_literal: true

class LandingPageController < ApplicationController
  def show
    if user_signed_in? && current_user.business
      redirect_to business_dashboard_path
    elsif user_signed_in? && current_user.specialist
      redirect_to specialists_dashboard_path
    else
      redirect_to new_user_session_path
    end
  end
end
