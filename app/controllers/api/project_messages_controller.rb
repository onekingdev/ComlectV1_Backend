# frozen_string_literal: true

class Api::ProjectMessagesController < ApiController
  before_action :require_someone
  before_action :find_project

  def index
    render json: @project.messages.page(params[:page]).per(20).to_json
  end

  def create
    message = Message::Create.(@project, message_params.merge(sender: @someone, recipient: nil), @someone, nil)
    render json: message.to_json
  end

  private

  def find_project
    @project = @someone.local_projects.find(params[:project_id])
  end
end
