# frozen_string_literal: true

class Specialists::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_specialist!

  def show
    @specialist = Specialist.preload_associations.find(current_user.specialist.id)
    @financials = Specialist::Financials.for(current_specialist)
    @ratings = @specialist.ratings_combined
  end

  def locked
    redirect_to specialists_dashboard_path if current_specialist.dashboard_unlocked
  end
end
