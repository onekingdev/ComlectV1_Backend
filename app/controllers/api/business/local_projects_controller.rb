# frozen_string_literal: true

class Api::Business::LocalProjectsController < ApiController
  before_action :require_business!
  before_action :find_project, only: %i[show update]
  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    respond_with current_business.local_projects, each_serializer: LocalProjectSerializer
  end

  def show
    respond_with @local_project, serializer: LocalProjectSerializer
  end

  def create
    local_project = current_business.local_projects.build(local_project_params)
    # local_project.status = 'draft' if params[:draft].present?
    if local_project.save
      render json: local_project, status: :created
    else
      render json: local_project.errors, status: :unprocessable_entity
    end
  end

  def update
    if @local_project.update(local_project_params)
      respond_with @local_project, serializer: LocalProjectSerializer
    else
      render json: @local_project.errors, status: :unprocessable_entity
    end
  end

  private

  def find_project
    @local_project = current_business.local_projects.find(params[:id])
  end

  def local_project_params
    params.require(:local_project).permit(
      :title,
      :description,
      :starts_on,
      :status,
      :ends_on
    )
  end
end
