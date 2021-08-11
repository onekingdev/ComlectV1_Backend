# frozen_string_literal: true

class Api::Business::LocalProjectsController < ApiController
  before_action :require_business!
  before_action :authorize_action
  before_action :find_project, only: %i[show update destroy complete]
  before_action :ongoing_contracts, only: %i[destroy complete]
  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    projects = current_business.local_projects.includes(projects: %i[industries skills jurisdictions end_request extension timesheets])
    respond_with projects, each_serializer: LocalProjectSerializer
  end

  def show
    respond_with @local_project, serializer: LocalProjectSerializer
  end

  def create
    local_project = current_business.local_projects.build(local_project_params)
    # local_project.status = 'draft' if params[:draft].present?
    if local_project.save
      process_hide(local_project)
      render json: local_project, status: :created
    else
      render json: local_project.errors, status: :unprocessable_entity
    end
  end

  def update
    if @local_project.update(local_project_params)
      process_hide(@local_project)
      respond_with @local_project, serializer: LocalProjectSerializer
    else
      render json: @local_project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @ongoing_contracts.count.positive?
      respond_with @ongoing_contracts, each_serializer: ProjectSerializer, status: :unprocessable_entity
    else
      @local_project.destroy
      respond_with @local_project, status: :ok
    end
  end

  def complete
    if @ongoing_contracts.count.positive?
      respond_with @ongoing_contracts, each_serializer: ProjectSerializer, status: :unprocessable_entity
    else
      @local_project.update(status: 'complete')
      respond_with @local_project, status: :ok
    end
  end

  private

  def find_project
    @local_project = current_business.local_projects.find(params[:id])
  end

  def process_hide(lproject)
    return unless local_project_params.to_h.key?(:hide_on_calendar)
    if local_project_params[:hide_on_calendar] == true
      current_user.hide_local_project(lproject.id)
    elsif local_project_params[:hide_on_calendar] == false
      current_user.show_local_project(lproject.id)
    end
  end

  def ongoing_contracts
    @ongoing_contracts = @local_project.projects.where(status: 'published').where.not(specialist_id: nil)
  end

  def local_project_params
    params.require(:local_project).permit(
      :title,
      :description,
      :starts_on,
      :status,
      :ends_on,
      :hide_on_calendar
    )
  end
end
