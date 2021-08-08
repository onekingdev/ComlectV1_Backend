# frozen_string_literal: true

class Api::DirectMessagesController < ApiController
  before_action :require_someone!
  skip_before_action :verify_authenticity_token

  def show
    @threads = Message.direct.threads_for(@current_someone)
    all_threads = []
    @threads.each do |thread|
      all_threads.push(thread)
    end
    if all_threads
      respond_with threads: all_threads
    else
      respond_with errors: 'no_threads'
    end
  end

  def index
    bid, sid = if @current_someone.class.name.include?('Business')
      [@current_someone.id,
       Specialist.find(params[:recipient_id])]
    elsif @current_someone.class.name.include?('Specialist')
      [Business.find(params[:recipient_id]),
       @current_someone.id]
    end

    messages = Message.business_specialist(bid, sid).direct.page(params[:page]).per(20)
    render json: messages.to_json
  end

  def create
    if message_params[:message].nil? && message_params[:file].nil?
      render json: { errors: I18n.t('api.direct_messages.empty_message') }
      return
    end

    recipient = if @current_someone.class.name.include? 'Business'
      Specialist.find(params[:recipient_id])
    elsif @current_someone.class.name.include? 'Specialist'
      Business.find(params[:recipient_id])
    end

    message = Message::Create.call(nil, message_params.merge(sender: @current_someone, recipient: recipient), @current_someone, recipient)
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
