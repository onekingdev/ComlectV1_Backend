# frozen_string_literal: true

class Api::Business::LocalProjectsController < ApiController
  before_action :require_business!

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    respond_with paginate(current_business.local_projects), each_serializer: LocalProjectSerializer
  end

  def show
    local_project = current_business.local_projects.find(params[:id])
    respond_with local_project, serializer: LocalProjectSerializer
  end

  def create
    local_project = current_business.local_projects.build(local_project_params)
    if local_project.save
      render json: local_project, status: :created
    else
      render json: local_project.errors, status: :unprocessable_entity
    end
  end

  private

  def local_project_params
    params.require(:local_project).permit(
      :title,
      :description,
      :starts_on,
      :ends_on
    )
  end
end
