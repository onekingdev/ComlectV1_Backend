# frozen_string_literal: true

class Api::Specialist::ProjectsController < ApiController
  before_action :require_specialist!

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    render json: Project::Search.new(search_params).results
  end

  private

  def search_params
    project_search_params = params
    return {} unless project_search_params
    project_search_params.permit(
      :project_type, :sort_by, :keyword, :experience, :regulator, :location_type, :location, :location_range,
      :lat, :lng, :project_value, :page,
      industry_ids: [], jurisdiction_ids: [], skill_names: []
    )
  end
end
