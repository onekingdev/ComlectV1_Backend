# frozen_string_literal: true

class Api::Specialist::ProjectsController < ApiController
  before_action :require_specialist!
  before_action :retrieve_project, only: %i[local calendar_show calendar_hide]
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

  def local
    respond_with @project.local_project, serializer: LocalProjectSerializer
  end

  def calendar_hide
    lproject = @project.local_project
    current_user.hide_local_project(lproject.id)
    respond_with lproject, serializer: LocalProjectSerializer
  end

  def calendar_show
    lproject = @project.local_project
    current_user.show_local_project(lproject.id)
    respond_with lproject, serializer: LocalProjectSerializer
  end

  private

  def retrieve_project
    @project = policy_scope(Project).find(params[:project_id])
  end

  def search_params
    params.permit(
      :project_type, :sort_by, :keyword, :regulator, :location_type, :location, :location_range,
      :lat, :lng, :page, :pricing_type,
      industry_ids: [], jurisdiction_ids: [], skill_names: [], experience: [], budget: []
    )
  end
end
