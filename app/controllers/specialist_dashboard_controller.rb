# frozen_string_literal: true
class SpecialistDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_specialist!

  def show
    @specialist = current_user.specialist
  end
end
