# frozen_string_literal: true

class Api::DirectMessagesController < ApiController
  before_action :require_someone!

  def index
    bid, sid = if @someone.class.name == 'Business'
                 [@someone.id,
                  Specialist.find_by(username: params[:recipient_username]).id]
               elsif @someone.class.name == 'Specialist'
                 [Business.find_by(username: params[:recipient_username]).id,
                  @someone.id]
               end
    messages = Message.business_specialist(bid, sid).direct.page(params[:page]).per(20)
    render json: messages.to_json
  end

  def create
    recipient = if @someone.class.name == 'Business'
                  Specialist.find_by(username: params[:recipient_username])
                elsif @someone.class.name == 'Specialist'
                  Business.find_by(username: params[:recipient_username])
                end
    message = Message::Create.(nil, message_params.merge(sender: @someone, recipient: recipient), @someone, recipient)
    if message.persisted?
      render json: message
    else
      render json: message.errors
    end
  end

  private

  def message_params
    params.require(:message).permit(:message, :file)
  end
end
