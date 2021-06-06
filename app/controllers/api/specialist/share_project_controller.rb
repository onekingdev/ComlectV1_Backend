# frozen_string_literal: true

class Api::Specialist::ShareProjectController < ApiController
  before_action :require_specialist!
  skip_before_action :verify_authenticity_token

  def create
    @project = Project.find_by(id: project_params[:project_id])
    if @project
      authorize @project, :share?
      @share = Project::Share.for(@project, share_params)
      if @share.valid?
        @share.send!
        respond_with project: @project.id, status: :ok
      else
        respond_with @share.errors, status: :unprocessable_entity
      end
    else
      respond_with status: :project_not_found
    end
  end

  private

  def share_params
    params.require(:share_project).permit(:email).merge(user: current_user)
  end

  def project_params
    params.permit(:project_id)
  end
end
