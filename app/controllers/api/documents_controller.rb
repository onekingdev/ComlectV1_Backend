# frozen_string_literal: true

class Api::DocumentsController < ApiController
  before_action :require_someone!
  before_action :find_local_project

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    respond_with @local_project.documents.where.not(file_data: nil), each_serializer: DocumentSerializer
  end

  def create
    document = @local_project.documents.create(document_params.merge(owner: @current_someone, local_project: @local_project))
    respond_with document, serializer: DocumentSerializer
  end

  def destroy
    document = @local_project.documents.find(params[:id])
    if document.owner == @current_someone
      if document.destroy
        respond_with document, serializer: DocumentSerializer
      else
        render json: { error: I18n.t('api.documents.cannot_destroy') }, status: :unprocessable_entity
      end
    else
      render json: { error: I18n.t('api.documents.not_owner') }, status: :unprocessable_entity
    end
  end

  private

  def find_local_project
    @local_project = @current_someone.local_projects.find(params[:project_id])
  end

  def document_params
    params.permit(:file)
  end
end
