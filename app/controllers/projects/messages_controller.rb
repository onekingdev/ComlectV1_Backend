# frozen_string_literal: true
class Projects::MessagesController < ApplicationController
  before_action :require_specialist!
  before_action :find_project

  def index
    Notification.clear! current_user, :specialist_got_project_message, @project
    @messages = @project.messages.recent.page(params[:page]).per(5)
    respond_to do |format|
      format.html do
        return render_messages if params[:page]
        render partial: 'thread', locals: { messages: @messages, me: current_specialist, them: @project.business }
      end
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    @message = @project.messages.create(message_params.merge(sender: current_specialist, recipient: @project.business))
    respond_to do |format|
      format.js do
        render :new if @message.new_record?
      end
      format.html do
        notice = @message.new_record? ? 'Could not save your message' : nil
        redirect_to project_dashboard_path(@project), notice: notice
      end
    end
    Notification::Deliver.got_project_message!(@message) if @message.persisted?
  end

  private

  def render_messages
    render partial: 'messages/message',
           collection: @messages.map(&method(:decorate)).reverse,
           locals: { me: current_specialist, them: @project.business }
  end

  def message_params
    params.require(:message).permit(:message)
  end

  def find_project
    @project = current_specialist.projects.find(params[:project_id])
  end
end
