# frozen_string_literal: true
class Business::ProjectMessagesController < ApplicationController
  before_action :require_business!
  before_action :find_project

  def index
    @messages = @project.messages.recent.limit(5)
    respond_to do |format|
      format.html do
        # TODO: @project.specialist
        render partial: 'thread', locals: { messages: @messages, me: current_business, them: Specialist.first }
      end
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    @message = @project.messages.create(message_params.merge(sender: current_business, recipient: Specialist.first))
    respond_to do |format|
      format.js do
        render :new if @message.new_record?
      end
      format.html do
        notice = @message.new_record? ? 'Could not save your message' : nil
        redirect_to business_project_dashboard_path(@project), notice: notice
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:message, :file)
  end

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end
end
