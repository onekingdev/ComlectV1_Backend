# index show

# frozen_string_literal: true

class Api::ProjectExtensionsController < ApiController
  before_action :require_someone!
  before_action :find_project

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def create
    return render json: { new_end_date: ['Required field'] }, status: :unprocessable_entity if params[:new_end_date].blank?
    if ProjectExtension::Request.process!(@project, params.require(:new_end_date), @current_someone)
      render json: { project: @project }
    else
      render json: { new_end_date: ['Internal error'] }, status: :unprocessable_entity
    end
  end

  def update
    return render_404 unless @project.extension_requested?
    if ProjectExtension::Request.confirm_or_deny!(@project, params.slice(:confirm, :deny), @current_someone)
      render json: { success: 'A project extensions has been processed', project: @project }
    else
      render json: { error: 'Should be confirmed from the other side' }
    end
  end

  private

  def find_project
    @project = @current_someone.projects.preload_association.find(params[:project_id])
  end
end
