# frozen_string_literal: true

class Api::DirectMessagesController < ApiController
  before_action :require_someone!
  skip_before_action :verify_authenticity_token

  def index
    bid, sid = if @current_someone.class.name == 'Business'
                 [@current_someone.id,
                  Specialist.find_by(username: params[:recipient_username]).id]
               elsif @current_someone.class.name == 'Specialist'
                 [Business.find_by(username: params[:recipient_username]).id,
                  @current_someone.id]
               end
    messages = Message.business_specialist(bid, sid).direct.page(params[:page]).per(20)
    render json: messages.to_json
  end

  def create
    recipient = if @current_someone.class.name.include? 'Business'
                  Specialist.find_by(username: params[:recipient_username])
                elsif @current_someone.class.name.include? 'Specialist'
                  Business.find_by(username: params[:recipient_username])
                end
    message = Message::Create.(nil, message_params.merge(sender: @current_someone, recipient: recipient), @current_someone, recipient)
    if !message.nil?
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
