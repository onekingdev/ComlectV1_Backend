# frozen_string_literal: true

class Api::ReminderMessagesController < ApiController
  before_action :require_someone!
  before_action :find_reminder
  skip_before_action :verify_authenticity_token

  def index
    respond_with @reminder.messages.includes(:sender, :recipient).page(params[:page]).per(20), each_serializer: MessageSerializer
  end

  def create
    message = Message::Create.call(@reminder, message_params.merge(sender: @current_someone, recipient: nil), @current_someone, nil)
    if message.persisted?
      respond_with message, serializer: MessageSerializer
    else
      render json: { errors: message.errors.to_json }
    end
  end

  private

  def find_reminder
    @reminder = @current_someone.reminders.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:message, :file)
  end
end
