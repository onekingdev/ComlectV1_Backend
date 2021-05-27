# frozen_string_literal: true

class Api::ProjectMessagesController < ApiController
  before_action :require_someone!
  before_action :find_project

  def index
    render json: @project.messages.page(params[:page]).per(20).to_json
  end

  def create
    message = Message::Create.(@project, message_params.merge(sender: @current_someone, recipient: nil), @current_someone, nil)
    if message.persisted?
      render json: message.to_json
    else
      render json: { errors: message.errors.to_json }
    end
  end

  private

  def find_project
    @project = @current_someone.local_projects.find(params[:project_id])
  end

  def message_params
    params.require(:message).permit(:message, :file)
  end
end
