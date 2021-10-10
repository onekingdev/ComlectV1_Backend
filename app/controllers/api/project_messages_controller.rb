# frozen_string_literal: true

class Api::ProjectMessagesController < ApiController
  before_action :require_someone!
  before_action :find_project
  skip_before_action :verify_authenticity_token

  def index
    specialist_id = @current_someone.id if @current_someone.class.name.include?('Specialist')
    specialist_id = current_user.specialist.id if current_user.specialist

    updatey = if specialist_id.nil?
      @project
    else
      LocalProjectsSpecialist.find_by(specialist_id: specialist_id, local_project_id: @project.id)
    end
    last_msg_id = @project.messages.last&.id
    updatey.update_column('last_read_message_id', last_msg_id) unless last_msg_id.nil?
    respond_with @project.messages.includes(:sender, :recipient).page(params[:page]).per(20), each_serializer: MessageSerializer
  end

  def create
    message = Message::Create.call(@project, message_params.merge(sender: (current_user.specialist || @current_someone), recipient: nil), nil)
    @project.update_column('has_unread_messages', true)
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
