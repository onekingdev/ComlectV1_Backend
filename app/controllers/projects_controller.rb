# frozen_string_literal: true

class ProjectsController < ApplicationController
  prepend_before_action :authenticate_user!
  before_action :require_specialist!

  def index
    @search = Project::Search.new(search_params)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @project = policy_scope(Project).find(params[:id])
  end

  private

  def search_params
    project_search_params = params[:project_search]
    return {} unless project_search_params
    project_search_params.permit(
      :project_type, :sort_by, :keyword, :experience, :regulator, :location_type, :location, :location_range,
      :lat, :lng, :project_value, :page,
      industry_ids: [], jurisdiction_ids: [], skill_names: []
    )
  end
end
