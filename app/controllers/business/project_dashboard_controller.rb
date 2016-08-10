# frozen_string_literal: true
class Business::ProjectDashboardController < ApplicationController
  before_action :require_business!

  def show
    @project = current_business.projects.find(params[:project_id])
  end
end
