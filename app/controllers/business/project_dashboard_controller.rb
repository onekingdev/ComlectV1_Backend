# frozen_string_literal: true
class Business::ProjectDashboardController < ApplicationController
  prepend_before_action :find_project, only: :show
  prepend_before_action :require_business!
  skip_before_action :check_unrated_project, if: -> { action_name == 'show' && @project&.requires_business_rating? }

  private

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end
end
