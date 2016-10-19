# frozen_string_literal: true
class Business::ProjectMessagesController < ApplicationController
  before_action :require_business!
  before_action :find_project

  def index
    Notification.clear! current_user, :business_got_project_message, @project
    @messages = @project.messages.recent.page(params[:page]).per(5)
    respond_to do |format|
      format.html do
        return render_messages if params[:page]
        render partial: 'thread', locals: { messages: @messages, me: current_business, them: @project.specialist }
      end
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    @message = @project.messages.create(message_params.merge(sender: current_business, recipient: @project.specialist))
    respond_to do |format|
      format.js do
        render :new if @message.new_record?
      end
      format.html do
        notice = @message.new_record? ? 'Could not save your message' : nil
        redirect_to business_project_dashboard_path(@project), notice: notice
      end
    end
    Notification::Deliver.got_project_message!(@message) if @message.persisted?
  end

  private

  def render_messages
    render partial: 'messages/message',
           collection: @messages.map(&method(:decorate)).reverse,
           locals: { me: current_business, them: @project.specialist }
  end

  def message_params
    params.require(:message).permit(:message, :file)
  end

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end
end
