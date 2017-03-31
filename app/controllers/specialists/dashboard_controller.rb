# frozen_string_literal: true
class Specialists::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_specialist!

  def show
    @specialist = Specialist.preload_associations.find(current_user.specialist.id)
    @financials = Specialist::Financials.for(current_specialist)
    @ratings = @specialist.ratings_received.preload_associations
  end
end
