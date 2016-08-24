# frozen_string_literal: true
class MessagesController < ApplicationController
  def index
    @threads = Message.threads_for(@sender)
    @thread = @threads.first
    render_thread(@thread, @sender) if request.xhr?
  end

  def new
    type, id = params.require(:recipient_key).split('/')
    @message = @sender.sent_messages.new(recipient_type: type, recipient_id: id)
  end

  def create
    @message = @sender.sent_messages.new(message_params)
    render :new unless @message.send!
  end

  def show
    direct, thread_type, thread_id = params.require(:thread_key).split('/')
    scope = @sender.messages.recent.preload_associations
    if direct == 'direct'
      @thread = scope.between(thread_type, thread_id).first
    else
      thread_id = thread_type
      thread_type = direct
      @thread = scope.find_by(thread_type: thread_type, thread_id: thread_id)
    end

    render_thread(@thread, @sender) if params.key?(:page)
  end

  private

  def render_thread(thread, sender)
    render partial: 'message',
           collection: thread.messages.page(params[:page]).per(5).map(&method(:decorate)).reverse,
           locals: { me: sender }
  end

  def message_params
    params.require(:message).permit(:recipient_type, :recipient_id, :message)
  end
end
