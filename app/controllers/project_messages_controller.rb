# frozen_string_literal: true
class ProjectMessagesController < ApplicationController
  before_action :find_project

  def index
    @messages = @project.messages.recent.page(params[:page]).per(20)
    respond_to do |format|
      format.html do
        return render_messages if params[:page]
        render partial: 'thread', locals: { messages: @messages, me: sender, them: recipient }
      end
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    @message = Message::Create.(@project, message_params.merge(sender: sender, recipient: recipient))
    respond_to do |format|
      format.js do
        render :new if @message.new_record?
      end
      format.html do
        alert = @message.new_record? ? @message.errors.messages.values.flatten.to_sentence : nil
        redirect_to path_after_create, alert: alert
      end
    end
  end

  private

  def render_messages
    render partial: 'messages/message',
           collection: @messages.map(&method(:decorate)).reverse,
           locals: { me: sender, them: recipient }
  end

  def message_params
    params.require(:message).permit(:message)
  end

  def find_project
    @project = sender.projects.find(params[:project_id])
  end
end
