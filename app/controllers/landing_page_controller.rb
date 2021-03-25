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
    # freg_cnt = Specialist.where(former_regulator: true).count
    # @former_regulators_percent = 100
    # @former_regulators_percent = freg_cnt * 100 / Specialist.count if freg_cnt != 0
    # Specialist.count
    # years_of_xp = Specialist.join_experience.all.where(work_experiences: { compliance: true }).collect(&:years_of_experience)

    # @avg_xp_years = if years_of_xp.count.positive?
    #                   years_of_xp.sum / years_of_xp.count
    #                 else
    #                   0
    #                 end

    # respond_to :html
  end
end
