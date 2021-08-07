# index show

# frozen_string_literal: true

class Api::ProjectExtensionsController < ApiController
  before_action :require_someone!
  before_action :find_project

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def create
    return render json: { ends_on: ['Required field'] }, status: :unprocessable_entity if params[:ends_on].blank?
    if ProjectExtension::Request.process!(@project, extension_params, @current_someone)
      render json: { project: @project }
    else
      render json: { ends_on: ['Internal error'] }, status: :unprocessable_entity
    end
  end

  def update
    return render_404 unless @project.extension_requested?
    if ProjectExtension::Request.confirm_or_deny!(@project, params.slice(:confirm, :deny), @current_someone)
      render json: { success: I18n.t('api.project_extensions.processed'), project: @project }
    else
      render json: { error: I18n.t('api.project_extensions.confirm_from_other_side') }
    end
  end

  private

  def find_project
    @project = @current_someone.projects.preload_association.find(params[:project_id])
  end

  def extension_params
    params.permit(
      :starts_on,
      :ends_on,
      :role_details,
      :key_deliverables,
      :fixed_budget,
      :hourly_rate,
      :ends_on_only
    )
  end
end
