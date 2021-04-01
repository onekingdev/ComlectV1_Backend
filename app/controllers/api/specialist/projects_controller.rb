# frozen_string_literal: true

class Api::Specialist::ProjectsController < ApiController
  before_action :require_specialist!
  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    results = Project::Search.new(search_params).results
    respond_with paginate results, each_serializer: ProjectSerializer
  end

  def show
    project = policy_scope(Project).find(params[:id])
    respond_with project, serializer: ProjectSerializer
  end

  def my
    respond_with paginate current_specialist.projects.active +
                          current_specialist.applied_projects.visible, each_serializer: ProjectSerializer
  end

  private

  def search_params
    params.permit(
      :project_type, :sort_by, :keyword, :regulator, :location_type, :location, :location_range,
      :lat, :lng, :page, :pricing_type,
      industry_ids: [], jurisdiction_ids: [], skill_names: [], experience: [], budget: []
    )
  end
end
