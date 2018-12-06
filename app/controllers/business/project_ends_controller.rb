# frozen_string_literal: true

class Business::ProjectEndsController < ApplicationController
  before_action :require_business!
  before_action :find_project
  before_action :authenticate_user!

  def create
    @request = ProjectEnd::Request.process! @project
    redirect_to business_project_dashboard_path(@project), notice: 'Project end requested'
  end

  private

  def find_project
    @project = current_business.projects.preload_associations.find(params[:project_id])
  end
end
