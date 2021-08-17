# frozen_string_literal: true

class Api::ProjectMessagesController < ApiController
  before_action :require_someone!
  before_action :find_project
  skip_before_action :verify_authenticity_token

  def index
    respond_with @project.messages.includes(:sender, :recipient).page(params[:page]).per(20), each_serializer: MessageSerializer
  end

  def create
    message = Message::Create.call(@project, message_params.merge(sender: @current_someone, recipient: nil), @current_someone, nil)
    if message.persisted?
      respond_with message, serializer: MessageSerializer
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
